let wasmWorker = new Worker('../assets/scripts/halloween/wasm-worker.js');

var canvas, ctx, img, pseudoCanvas, pseudoCtx, width, height, checkbox;
var inited = false;

var inited = false;

function init() {
    checkbox = document.getElementById("ghosts");
    checkbox.onchange = updateGhosts;

    canvas = document.getElementById("overlaycanvas");
    ctx = canvas.getContext("2d");
    
    img = document.getElementById('cammie-feed');
    
    pseudoCanvas = document.createElement("canvas");
    pseudoCtx = pseudoCanvas.getContext("2d");

    update_w_h();
}

function updateGhosts() {
    if(checkbox.checked) {
        update_coolness();
    }
}

function update_w_h() {
    width = img.width;
    height = img.height;

    pseudoCanvas.width = width;
    pseudoCanvas.height = height;

    canvas.width = width;
    canvas.height = height;
}

function update_coolness() {
    if(!inited) {
        init();
        inited = true;
    }
    if(! checkbox.checked) {
        if(ctx) {
            ctx.clearRect(0,0, width, height);
        }
        return;
    }
    
    pseudoCtx.clearRect(0, 0, width, height);
    pseudoCtx.drawImage(img, 0, 0);
    let message = { cmd: 'faceDetect', img: pseudoCtx.getImageData(0, 0, width, height) };
    wasmWorker.postMessage(message);
};

wasmWorker.onmessage = function (e) {
    var img2 = document.createElement("img");
    img2.src = "../assets/scripts/halloween/Ghost.jpg";
    
    if(e.data.features) {
        ctx.clearRect(0,0, width, height);
        
        // e.data.features.push({x: 10, y: 10, width: 100, height: 100});
        for (let i = 0; i < e.data.features.length; i++) {
            let rect = e.data.features[i];
            ctx.fillStyle = 'rgb(0,0,0)';
            ctx.drawImage(img2, rect.x, rect.y, rect.width, rect.height);
        }

        update_coolness();
    }
}


setTimeout(update_coolness, 3000);
