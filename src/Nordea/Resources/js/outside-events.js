const outsideClickListener = e => {
  document.querySelectorAll('.outside-click').forEach(el => {
    if (!el.parentElement.contains(e.target)) {
      el.dispatchEvent(new CustomEvent('outside-click'));
    }
  });
};

const outsideFocusListener = e => {
  document.querySelectorAll('.outside-focus').forEach(el => {
    if (!el.parentElement.contains(e.target)) {
      el.dispatchEvent(new CustomEvent('outside-focus'));
    }
  });
};

document.addEventListener('click', outsideClickListener);
document.addEventListener('focusin', outsideFocusListener);
