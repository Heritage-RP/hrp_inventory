// UI theme (fork patch, Heritage-RP/PRODUCTION-SERVER#476). The client reads the replicated convar `hrp_ui_theme`
// (modules/theme/shared.lua) and sends it in the `init` message, then as `setTheme` when it changes. `neutral` (the
// default) is the upstream look; `heritage` is the green terminal look. index.scss styles both from `data-theme` on
// <html>. In a browser, `?theme=heritage` picks one for development and screenshots.

export const THEMES = ['neutral', 'heritage'] as const;
export type ThemeName = (typeof THEMES)[number];

const FONTS: Partial<Record<ThemeName, string>> = {
  heritage: 'https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap',
};

/** The theme `value` names (case-insensitive, trimmed), `neutral` for anything else. */
export function themeOf(value: unknown): ThemeName {
  const name = typeof value === 'string' ? value.trim().toLowerCase() : '';
  return (THEMES as readonly string[]).includes(name) ? (name as ThemeName) : 'neutral';
}

/** Sets `data-theme` on <html> and loads the theme's web font once. */
export function applyTheme(value: unknown): ThemeName {
  const theme = themeOf(value);
  document.documentElement.dataset.theme = theme;

  const font = FONTS[theme];
  if (font && !document.querySelector(`link[data-theme-font='${theme}']`)) {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = font;
    link.dataset.themeFont = theme;
    document.head.appendChild(link);
  }

  return theme;
}

/** The theme a page URL forces (`?theme=heritage`), null without one. */
export function themeFromUrl(search: string): ThemeName | null {
  const value = new URLSearchParams(search).get('theme');
  return value === null ? null : themeOf(value);
}
