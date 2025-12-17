/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // Primary Green Palette
        primary: {
          DEFAULT: '#22C55E',
          light: '#4ADE80',
          dark: '#16A34A',
          50: '#F0FDF4',
          100: '#DCFCE7',
          200: '#BBF7D0',
          300: '#86EFAC',
          400: '#4ADE80',
          500: '#22C55E',
          600: '#16A34A',
          700: '#15803D',
          800: '#166534',
          900: '#14532D',
        },
        // Background colors
        background: {
          DEFAULT: '#0C1810',
          light: '#0F1F15',
        },
        surface: {
          DEFAULT: '#132419',
          light: '#1A3324',
        },
        // Accent
        accent: '#A3E635',
        // Text
        'text-primary': '#FFFFFF',
        'text-secondary': '#A1C4AD',
        'text-muted': '#5E8A6D',
      },
      fontFamily: {
        sans: ['DM Sans', 'system-ui', 'sans-serif'],
        serif: ['Fraunces', 'Georgia', 'serif'],
      },
      borderRadius: {
        '4xl': '2rem',
        '5xl': '2.5rem',
      },
      animation: {
        'float': 'float 6s ease-in-out infinite',
        'blob': 'blob 8s ease-in-out infinite',
        'pulse-soft': 'pulse-soft 4s ease-in-out infinite',
        'breathe': 'breathe 4s ease-in-out infinite',
        'gradient': 'gradient-flow 6s ease infinite',
        'shimmer': 'shimmer 2s infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0) rotate(0deg)' },
          '50%': { transform: 'translateY(-20px) rotate(2deg)' },
        },
        blob: {
          '0%, 100%': { borderRadius: '60% 40% 30% 70% / 60% 30% 70% 40%' },
          '25%': { borderRadius: '30% 60% 70% 40% / 50% 60% 30% 60%' },
          '50%': { borderRadius: '50% 60% 30% 60% / 40% 30% 60% 50%' },
          '75%': { borderRadius: '40% 30% 60% 50% / 60% 50% 40% 30%' },
        },
        'pulse-soft': {
          '0%, 100%': { opacity: 0.4, transform: 'scale(1)' },
          '50%': { opacity: 0.6, transform: 'scale(1.05)' },
        },
        breathe: {
          '0%, 100%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.1)' },
        },
        'gradient-flow': {
          '0%': { backgroundPosition: '0% 50%' },
          '50%': { backgroundPosition: '100% 50%' },
          '100%': { backgroundPosition: '0% 50%' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
      },
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic': 'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
        'green-glow': 'radial-gradient(circle, rgba(34, 197, 94, 0.15) 0%, transparent 70%)',
      },
      boxShadow: {
        'glow': '0 0 60px rgba(34, 197, 94, 0.3)',
        'glow-sm': '0 0 30px rgba(34, 197, 94, 0.2)',
        'glow-lg': '0 0 100px rgba(34, 197, 94, 0.4)',
      },
    },
  },
  plugins: [],
}
