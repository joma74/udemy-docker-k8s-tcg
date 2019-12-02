import React from "react"
import { Link } from "react-router-dom"

export default () => {
	return (
		<div>
			I am som other page!
			<Link to="/">Go back home</Link>
		</div>
	)
}
