const listener = e => {
  document.querySelectorAll('.outside-click').forEach(el => {
    if (el.dataset.isActive === 'true' && !el.parentElement.contains(e.target)) {
      el.parentElement.dispatchEvent(new CustomEvent('outsideclick'));
    }
  });
};

document.addEventListener('click', listener);
