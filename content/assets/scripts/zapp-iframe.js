let setsize = false;
let dropwidth = 0;
let dropheight = 0;
let opened = false;

const outsideclickhandler = (ev) => {
    const path = ev.composedPath();
    const clickedInside =
        path.some((n) => n && n.id === 'zappbutton') ||
        path.some((n) => n && n.id === 'zappdropdown');
    if (!clickedInside) {
        opened = false;
        const dropdown = document.getElementById("zappdropdown");
        dropdown.style.visibility = opened ? "visible" : "hidden";
        dropdown.contentWindow.postMessage({type: "outsideclick"}, "*")
        document.getElementById("zappbutton").contentWindow.postMessage({type: "outsideclick"}, "*")
        dropdown.contentWindow.postMessage({type: "outsideclick"}, "*")
    }
};
window.addEventListener("click", outsideclickhandler);
const GAP = 4;

function position(){
    var dropdownroot = document.getElementById("zappdropdown")
    const vrect = document.getElementById("zappbutton").getBoundingClientRect();

    const vw = window.innerWidth;
    const vh = window.innerHeight;

    let left = vrect.x;
    let topBelow = vrect.y + vrect.height + GAP;
    let top = topBelow;

    // Horizontal clamp
    if(left + dropwidth > vw - GAP) left = Math.max(GAP, vw - dropwidth - GAP);
    if(left < GAP) left = GAP;

    // Prefer below, fallback above if overflow
    if(top + dropheight > vh - GAP){
        const topAbove = vrect.y - dropheight - GAP;
        if(topAbove >= GAP){
            top = topAbove;
        }else{
        // Clamp inside viewport
            top = Math.max(GAP, Math.min(top, vh - dropheight - GAP));
        }
    }

    // dropdownroot.style.left = left + "px";
    dropdownroot.style.transform = `translatex(${left}px)`
    dropdownroot.style.top = top + "px";
}

function openAnimation(){
    const root = document.getElementById("zappdropdown")
    // Avoid duplicating listeners
    if(!root._repositionBound){
        const handler = () => position();
        window.addEventListener("resize", handler);
        window.addEventListener("scroll", handler, true);
        root._repositionBound = true;
    }
    position();
}

window.onmessage = function(e){
    const button = document.getElementById("zappbutton");
    const dropdown = document.getElementById("zappdropdown");
    try{
        let msg = JSON.parse(e.data);
        if(msg.type === "buttonclick"){
        opened = !opened;
            dropdown.style.visibility = opened ? "visible" : "hidden";
            dropdown.contentWindow.postMessage({type: 'state', state: opened}, "*")
            if(opened) openAnimation();
        }else if(msg.type === "dropdown-box" && !setsize){
            setsize = true;
            dropwidth = msg.box.width;
            dropheight = msg.box.height;
            dropdown.style.width = `${dropwidth}px`;
            dropdown.style.height = `${dropheight + 7}px`;
        }else if(msg.type === "state"){
            opened = msg.state;
            dropdown.style.visibility = opened ? "visible" : "hidden";
            button.contentWindow.postMessage(msg, "*")
        }
        else{
            console.error("no supported msg type: " + msg.type)
        }
    }catch(err){
        console.error(err);
    }
}