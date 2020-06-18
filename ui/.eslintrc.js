module.exports = {
    parser: 'babel-eslint',
    parserOptions: {
        ecmaVersion: 2018,
    },
    plugins: ['react', 'jsx-a11y', 'prettier'],
    env: {
        browser: true,
        node: true,
        es6: true,
    },
    extends: [
        'eslint:recommended',
        'plugin:import/errors',
        'plugin:import/warnings',
        'plugin:react/recommended',
        'plugin:jsx-a11y/recommended',
        'plugin:prettier/recommended',
        'prettier/react',
    ],
    globals: {
        'Sentry': 'readonly'
    },
    settings: {
        react: {
            version: 'detect',
        },
        'import/resolver': {
            'node': {
                'paths': ['src']
            }
        }
    },
    ignorePatterns: ['functions'],
    rules: {
        'react/prop-types': 'off',
        'jsx-a11y/no-static-element-interactions': 'off',
        'jsx-a11y/click-events-have-key-events': 'off',
        'jsx-a11y/no-noninteractive-element-interactions': 'off',
        'jsx-a11y/no-noninteractive-element-to-interactive-role': 'off',
    },
};