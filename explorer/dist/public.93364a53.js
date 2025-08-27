const addListener = (name)=>(e)=>{
        document.querySelectorAll('.' + name).forEach((el)=>{
            if (!el.parentElement.contains(e.target)) el.dispatchEvent(new CustomEvent(name));
        });
    };
document.addEventListener('click', addListener('outside-click'));
document.addEventListener('focusin', addListener('outside-focus'));

