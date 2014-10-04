/**
 * Menu Toggle
 */
(function(window, undefined){

	var document = window.document;

	document.querySelector('.js-mobile-expandable-toggle').addEventListener('click', toggleMenu);

	/**
	 * Toggle the menu
	 * Open if closed, close if opened.
	 * Accomplished by adding and removing the class .is-open
	 */
	function toggleMenu(e) {

		var el = document.querySelector('.js-mobile-expandable'),
				className = 'is-open';

		if (el.classList) {
			el.classList.toggle(className);
		} else {
			var classes = el.className.split(' ');
			var existingIndex = classes.indexOf(className);

			if (existingIndex >= 0)
				classes.splice(existingIndex, 1);
			else
				classes.push(className);

			el.className = classes.join(' ');
		}

		return false;

	}

})(window);