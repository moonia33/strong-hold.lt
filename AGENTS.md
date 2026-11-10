# Agentio pastabos — strong-hold.lt

## Serverio ribai (SVARBU — 2026-11-10 OOM incidentas)
- 2 vCPU / 3,8 GB RAM. `npm run build` (webpack + fork-ts-checker ~2 GB) + IDE serveris → OOM crash (CF 522 visoms svetainėms).
- **Draudžiama:** `npm run watch`, `dev`, storybook, keli build'ai vienu metu.
- **Build'as tik per systemd-run** (reikalingas root — agentas pats nepaleidžia; prašyti vartotojo arba kelti assets/ iš kitur):
  ```
  systemd-run --unit=sh-theme-build --uid=strong-hold --gid=strong-hold \
    --working-directory=/home/strong-hold/htdocs/strong-hold.lt/themes/mooniadesign-3 \
    -p MemoryMax=1700M -p MemorySwapMax=256M -p Nice=19 -p IOSchedulingClass=idle \
    -E PATH=/home/strong-hold/.nvm/versions/node/v20.19.4/bin:/usr/bin:/bin \
    -E HOME=/home/strong-hold \
    /home/strong-hold/.nvm/versions/node/v20.19.4/bin/npm run build
  ```
  Logas: `journalctl -u sh-theme-build`
- Geriausia praktika: buildinti lokaliai ir kelti tik `themes/mooniadesign-3/assets/`.

## Duomenys
- 2026-11-10 nukopijuota kategorija „Sandėliavimo lentynos ir stelažai“ (kategorijos 10–14, 24 prekės, filtrų šablonas „Stelažai“). Aprašymai išvalyti nuo MS Word šiukšlių — **neperrašyti**.
- Feature reikšmės: naudoti tik predefined (ne custom) — custom reikšmės dublikuoja `ps_facetedsearch` filtrus.

## Cache
- Po asset'ų pakeitimų: `php bin/console cache:clear` + `rm themes/mooniadesign-3/assets/cache/theme-*` + `PS_CCCCSS_VERSION`/`PS_CCCJS_VERSION` bump'as DB'e.
- Cloudflare cache'uoja HTML — kartais reikia Purge Everything.
