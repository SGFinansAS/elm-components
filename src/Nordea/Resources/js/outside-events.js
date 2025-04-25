const outsideClickListener = e => {
  document.querySelectorAll('.outside-click').forEach(el => {
    if (!el.parentElement.contains(e.target)) {
      el.parentElement.dispatchEvent(new CustomEvent('outsideclick'));
    }
  });
};

const outsideFocusListener = e => {
  document.querySelectorAll('.outside-focus').forEach(el => {
    if (!el.parentElement.contains(e.target)) {
      el.parentElement.dispatchEvent(new CustomEvent('outsidefocus'));
    }
  });
};

document.addEventListener('click', outsideClickListener);
document.addEventListener('focusin', outsideFocusListener);
