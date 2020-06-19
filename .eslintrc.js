module.exports = {
	extends: ['@10up/eslint-config/react'],
	plugins: ['markdown'],
	rules: {
		'no-plusplus': [2, { allowForLoopAfterthoughts: true }]
	}
};
