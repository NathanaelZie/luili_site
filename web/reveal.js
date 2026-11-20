// Animations au défilement (amélioration progressive).
// - [data-reveal] : les classes JX listées (anim:…, adur:…, adelay:…) sont
//   posées quand le bloc entre à l'écran ; il est masqué (o:0) d'ici là.
// - [data-count] : le nombre affiché est compté de 0 à sa valeur finale.
// Sans JavaScript, ou si l'utilisateur réduit les animations, le contenu
// reste affiché tel quel. Fichier local : compatible CSP script-src 'self'.
(() => {
  'use strict';
  if (!('IntersectionObserver' in window)) return;
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  const HIDDEN = 'o:0';

  const countUp = (el) => {
    const match = /^(\D*)(\d+)(.*)$/.exec(el.textContent.trim());
    if (!match) return;
    const [, before, digits, after] = match;
    const target = Number(digits);
    const start = performance.now();
    const duration = 1400;
    const tick = (now) => {
      const t = Math.min((now - start) / duration, 1);
      const eased = 1 - Math.pow(1 - t, 3);
      el.textContent = before + Math.round(target * eased) + after;
      if (t < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  };

  const show = (el) => {
    if (el.dataset.reveal) {
      el.classList.remove(HIDDEN);
      el.classList.add(...el.dataset.reveal.split(/\s+/).filter(Boolean));
    }
    if (el.hasAttribute('data-count')) countUp(el);
  };

  const observer = new IntersectionObserver((entries) => {
    for (const entry of entries) {
      if (!entry.isIntersecting) continue;
      observer.unobserve(entry.target);
      show(entry.target);
    }
  }, { rootMargin: '0px 0px -8% 0px', threshold: 0.05 });

  for (const el of document.querySelectorAll('[data-reveal], [data-count]')) {
    // Déjà visible au chargement : pas de masquage (évite un clignotement).
    if (el.getBoundingClientRect().top < window.innerHeight) {
      if (el.hasAttribute('data-count')) countUp(el);
      continue;
    }
    if (el.dataset.reveal) el.classList.add(HIDDEN);
    observer.observe(el);
  }
})();
