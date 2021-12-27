var canvas = document.getElementById('canvas');
var ctx = canvas.getContext('2d');
var rect = {};
var drag = false;
var imageObj = null;

function init() {
    imageObj = new Image();
    imageObj.onload = function () { ctx.drawImage(imageObj, 0, 0); };
    imageObj.src = 'http://www.html5canvastutorials.com/demos/assets/darth-vader.jpg';
    canvas.addEventListener('mousedown', mouseDown, false);
    canvas.addEventListener('mouseup', mouseUp, false);
    canvas.addEventListener('mousemove', mouseMove, false);
}

function mouseDown(e) {
    rect.startX = e.pageX - this.offsetLeft;
    rect.startY = e.pageY - this.offsetTop;
    drag = true;
}

function mouseUp() { drag = false; }

function mouseMove(e) {
    if (drag) {
        ctx.clearRect(0, 0, 500, 500);
        ctx.drawImage(imageObj, 0, 0);
        rect.w = (e.pageX - this.offsetLeft) - rect.startX;
        rect.h = (e.pageY - this.offsetTop) - rect.startY;
        ctx.strokeStyle = 'red';
        ctx.strokeRect(rect.startX, rect.startY, rect.w, rect.h);
    }
}
//
init();