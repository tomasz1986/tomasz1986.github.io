// ==UserScript==
// @name         Youtube Controls Always Visible
// @version      1.0.1
// @author       Tomasz Wilczyński
// @match        *://www.youtube.com/*
// @match        *://www.youtube-nocookie.com/*
// ==/UserScript==

(function() {
	'use strict';

	setInterval(() => {
		// Keep controls visible
		var container = document.getElementById('movie_player');
		container.classList.remove('ytp-autohide');

		// Getting played time
		var video = document.querySelector('.video-stream');
		var hours = Math.floor(video.currentTime / 3600);
		var minutes = Math.floor(video.currentTime / 60) - (hours * 3600);
		var seconds = Math.round(video.currentTime % 60);
		if (seconds < 10) {
			seconds = `0${seconds}`;
		}
		if (hours > 0 && minutes < 10) {
			minutes = `0${minutes}`
		}

		// Displaying played time
		var timeDisplay = document.querySelector('.ytp-time-current')
		timeDisplay.innerText = `${(hours > 0 ? `${hours}:` : '')}${minutes}:${seconds}`

		// Progress bar
		var percentagePlayed = video.currentTime / video.duration
		var progressBar = document.querySelector('.ytp-play-progress')
		progressBar.style = `left: 0px; transform: scaleX(${percentagePlayed})`

		// Scrubber button
		const scrubberButton = document.querySelector('.ytp-scrubber-container')
		scrubberButton.style = `left: 0px; transform: translateX(${percentagePlayed * video.offsetWidth}px)`

		// Buffered bar
		var percentageBuffered = video.buffered.end(0) / video.duration
		var bufferedBar = document.querySelector('.ytp-load-progress')
		bufferedBar.style = `left: 0px; transform: scaleX(${percentageBuffered})`
	}, 10)

	// Source - https://stackoverflow.com/a/65586795
	// Posted by Louys Patrice Bessette, modified by community.
	// Retrieved 2026-09-23, License - CC BY-SA 4.0
})();
