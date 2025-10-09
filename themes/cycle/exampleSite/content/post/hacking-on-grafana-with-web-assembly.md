---
title: "Hacking on Grafana with Web Assembly"
date: 2022-08-19T15:10:19-0400
lastmod: 2022-08-19T15:10:19-0400
slug: hacking-on-grafana-with-web-assembly
excerpt: "Grafana had a hack week this past week and I opted to work on WebAssembly(WASM)-related things. My vague original idea was to see if I could compile the Grafana server for WASM."
---

<aside class="pa2 bg-light-gray">
I _finally_ got around to pushing the code ([repo](https://github.com/asimpson/hackathon-2022-08-wasm)) I outline here to a S3 bucket as a demo: [http://wasm-hack-week-2022.s3-website-us-east-1.amazonaws.com](http://wasm-hack-week-2022.s3-website-us-east-1.amazonaws.com)
</aside>
[Grafana](https://grafana.com/) had a hack week this past week and I opted to work on WebAssembly(WASM)-related things. My vague original idea was to see if I could compile the Grafana server for WASM.

The original inspiration for this idea came from [Simon Willison’s work with Datasette Lite](https://simonwillison.net/2022/May/4/datasette-lite/). However, compiling Grafana as a WASM binary proved [difficult](https://github.com/golang/go/issues/32548) with existing [build constraints](https://pkg.go.dev/go/build#hdr-Build_Constraints). After spending some time trying to get that to work I changed course a bit and instead focused on compiling a basic `go` HTTP server as a WASM module. The new goal being to have a proof of concept that bundled the HTTP server as a WASM binary and intercepted any clicked links on the page and finally passed those links to be resolved by the `go` server in WASM. 

I used a [Web Worker](https://developer.mozilla.org/en-US/docs/WebAssembly/Concepts) to interact with the WASM binary. This frees up the main thread of the browser. To put the WASM binary into the worker I loaded the binary and sent a message that contained the binary as a [`WebAssembly.Module`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/Module). 

The Web Worker can then call any `go` functions that have been exposed via [`FuncOf`](https://pkg.go.dev/syscall/js#FuncOf). Once the `go` function returns data, the worker posts that response back to the main thread via another message.

```js
let module;
importScripts("wasm_exec.js")
go = new Go();

self.onmessage = async (e) => {
  if (e.data.type === "module") {
    module = e.data.module;
    return;
  }

  if (module) {
    console.log('Message received: ', e.data.path);
    const instance = await WebAssembly.instantiate(module, go.importObject);
    go.run(instance);
    postMessage(parsePath(e.data.path)); // parsePath is exposed via FuncOf
  }
}
```

Sidenote: I wish `go` could use the same pragma syntax `tinygo` uses to expose functions instead of the verbose `FuncOf`. There's [an issue](https://github.com/golang/go/issues/25612) but it has been open since 2018. 

Obviously, there is no `localhost` to listen on in a WASM environment. To get around that I created a bare bones [`ResponseWriter`](https://pkg.go.dev/net/http#ResponseWriter) and used that with the [`Request`](https://pkg.go.dev/net/http#Request) to run the Handler’s [`ServeHTTP`](https://pkg.go.dev/net/http#HandlerFunc.ServeHTTP) function which consults the routes that are defined and runs the matching handler code. This allowed me to use a build constraint (`setup.go` and `setup_js.go`) and keep my HTTP server functioning normally when run from a terminal but then also worked when run in a WASM context. Here's what those two files look like:

`setup`

```go
//go:build !js
// +build !js

package main

import (
	"fmt"
	"net/http"
)

func setup() {
	s := NewServer()
	err := http.ListenAndServe(":9001", s.mux)
	if err != nil {
		fmt.Println("error: ", err)
	}
}
```

`setup_js`

```go
package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"syscall/js"
)

type ResponseWriter struct {
	Body *bytes.Buffer
}

func (r ResponseWriter) Header() http.Header {
	return make(http.Header)
}

func (r ResponseWriter) Write(buf []byte) (int, error) {
	if r.Body != nil {
		r.Body.Write(buf)
	}
	return len(buf), nil
}

func (r ResponseWriter) WriteHeader(statusCode int) {}

func createWriter() ResponseWriter {
	return ResponseWriter{
		Body: new(bytes.Buffer),
	}
}

func parsePath(this js.Value, args []js.Value) interface{} {
	fmt.Println("args: ", args)
	server := NewServer()
	path := args[0].String()
	req, err := http.NewRequest(http.MethodGet, path, nil)

	if err != nil {
		fmt.Println("request error: ", err)
	}

	h, p := server.mux.Handler(req)

	fmt.Println("pattern: ", p)

	w := createWriter()

	h.ServeHTTP(w, req)

	b, err := ioutil.ReadAll(w.Body)

	if err != nil {
		fmt.Println("ioutil error: ", err)
	}

	return string(b)
}

func setup() {
	js.Global().Set("parsePath", js.FuncOf(parsePath))
}
```

## Conclusions

The PoC worked! It's pretty slick to see a HTTP server running in WASM return back the correct data when a link is clicked. However, in my opinion, WASM continues to be a "solution in search of a problem". Yes it's incredibly cool technology but so are the JS engines in Chrome, Firefox, and Safari. The sheer amount of money and engineering time being spent on making JS fast is a race no other technology can win at the moment.

That said, Go seems to have done decent work at providing the necessary pieces to make compiling to WASM not awful. 

Honestly, the thing that surprised and impressed me the most was working with Web Workers. They are seriously useful and seem to "just work".

## Links that helped me out along the way

- [Simon Willison’s post about Datasette Lite](https://simonwillison.net/2022/May/4/datasette-lite/)
- [Philippe Charrière's post](https://blog.suborbital.dev/foundations-wasm-in-golang-is-fantastic)
- [Roman Romadin's post](https://itnext.io/webassemply-with-golang-by-scratch-e05ec5230558)
