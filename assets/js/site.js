(() => {
  'use strict';
  const main = document.querySelector('main[data-page]');
  const year = document.querySelector('[data-year]');
  if (year) year.textContent = new Date().getFullYear();
  if (!main) return;
  // Preserve links shared before the single-page site was reorganized.
  if (main.dataset.page === 'about') {
    const oldSections = {
      '#research-focus': '/research/',
      '#working-papers': '/research/#working-papers',
      '#publications': '/research/#publications',
      '#students': '/lab/',
      '#teaching': '/teaching/'
    };
    const redirectOldSection = () => {
      const target = oldSections[window.location.hash];
      if (target) window.location.replace((main.dataset.baseurl || '') + target);
    };
    redirectOldSection();
    window.addEventListener('hashchange', redirectOldSection);
  }
  const controls = document.getElementById('research-controls');
  if (!controls) return;
  const buttons = [...controls.querySelectorAll('[data-topic]')];
  const papers = [...document.querySelectorAll('[data-paper]')];
  const groups = [...document.querySelectorAll('[data-paper-group]')];
  const select = document.getElementById('paper-status');
  const count = document.getElementById('result-count');
  const empty = document.getElementById('no-papers');
  const reset = document.getElementById('clear-filters');
  const validTopics = new Set(buttons.map(button => button.dataset.topic));
  const validStatuses = new Set([...select.options].map(option => option.value));
  let topic = 'all';
  function render() {
    let visible = 0;
    for (const paper of papers) {
      const matchesTopic = topic === 'all' || paper.dataset.topics.split(' ').includes(topic);
      const matchesStatus = select.value === 'all' || paper.dataset.status === select.value;
      paper.hidden = !(matchesTopic && matchesStatus);
      if (!paper.hidden) visible += 1;
    }
    for (const group of groups) group.hidden = ![...group.querySelectorAll('[data-paper]')].some(paper => !paper.hidden);
    for (const button of buttons) button.setAttribute('aria-pressed', String(button.dataset.topic === topic));
    count.textContent = visible + (visible === 1 ? ' paper' : ' papers');
    empty.hidden = visible > 0;
  }
  function readUrl() {
    const params = new URLSearchParams(window.location.search);
    topic = validTopics.has(params.get('topic')) ? params.get('topic') : 'all';
    select.value = validStatuses.has(params.get('status')) ? params.get('status') : 'all';
    render();
  }
  function updateUrl() {
    const url = new URL(window.location.href);
    topic === 'all' ? url.searchParams.delete('topic') : url.searchParams.set('topic', topic);
    select.value === 'all' ? url.searchParams.delete('status') : url.searchParams.set('status', select.value);
    url.hash = '';
    try { window.history.pushState({}, '', url); } catch (_) { /* local file preview */ }
    render();
  }
  for (const button of buttons) button.addEventListener('click', () => { topic = button.dataset.topic; updateUrl(); });
  select.addEventListener('change', updateUrl);
  reset.addEventListener('click', () => { topic = 'all'; select.value = 'all'; updateUrl(); });
  window.addEventListener('popstate', readUrl);
  readUrl();
  controls.hidden = false;
})();
