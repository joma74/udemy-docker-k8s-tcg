import React from "react"
import ReactDOM from "react-dom"
import App from "./App"
import ShallowRenderer from "react-test-renderer/shallow"

it("renders without crashing", async () => {
	const div = document.createElement("div")
	const renderer = ShallowRenderer.createRenderer()
	renderer.render(<App />, div)
	ReactDOM.unmountComponentAtNode(div)
})
