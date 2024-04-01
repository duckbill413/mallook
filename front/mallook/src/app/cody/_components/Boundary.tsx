import React from 'react';
import styles from "./drag.module.css";
export default React.forwardRef<HTMLDivElement, React.ComponentProps<'div'>>(function Boundary(
	props,
	ref,
) {

	return (
		<div
			{...props}
			ref={ref}
			className={
				styles.boundary + props.className
			}
		/>
	);
});