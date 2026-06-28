// Open all details tags before printing.
window.addEventListener('beforeprint', function() {
	var e = document.getElementsByTagName('details');
	var i = e.length;
	while (i--) {
		e[i].setAttribute('open','');
	}
})

// Close all details tags after printing.
window.addEventListener('afterprint', function() {
	var e = document.getElementsByTagName('details');
	var i = e.length;
	while (i--) {
		e[i].removeAttribute('open','');
	}
})
