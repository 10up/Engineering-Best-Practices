/**
 * Menu Toggle
 */
(function menuToggle(window) {
	const { document } = window;

	/**
	 * Toggle the menu
	 *
	 * Open if closed, close if opened.
	 * Accomplished by adding and removing the class .is-open
	 *
	 *
	 * @returns {void|boolean}
	 */
	function toggleMenu() {
		const el = document.querySelector('.js-mobile-expandable');
		const className = 'is-open';

		if (el.classList) {
			el.classList.toggle(className);
		} else {
			const classes = el.className.split(' ');
			const existingIndex = classes.indexOf(className);

			if (existingIndex >= 0) classes.splice(existingIndex, 1);
			else classes.push(className);

			el.className = classes.join(' ');
		}

		return false;
	}

	document.querySelector('.js-mobile-expandable-toggle').addEventListener('click', toggleMenu);
})(window);
