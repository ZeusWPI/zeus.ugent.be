var face_cascade, eye_cascade;

function loadFaceDetectTrainingSet() {
	if (face_cascade == undefined) {
		face_cascade = new cv.CascadeClassifier();
	}
}

function faceDetect(imageData) {
	loadFaceDetectTrainingSet();

	let img = cv.matFromArray(imageData, 24); // 24 for rgba

	let img_gray = new cv.Mat();
	cv.cvtColor(img, img_gray, cv.ColorConversionCodes.COLOR_RGBA2GRAY.value, 0);

	let faces = new cv.RectVector();
	let s1 = [0, 0];
	let s2 = [0, 0];
	face_cascade.detectMultiScale(img_gray, faces, 1.1, 3, 0, s1, s2);

	let rects = [];

	for (let i = 0; i < faces.size(); i += 1) {
		let faceRect = faces.get(i);
		rects.push({
			x: faceRect.x,
			y: faceRect.y,
			width: faceRect.width,
			height: faceRect.height
		});
	}

	postMessage({ features: rects, output: true });

	img.delete();
	faces.delete();
	img_gray.delete();
}

self.onmessage = function (e) {
	switch (e.data.cmd) {
		case 'faceDetect':
			faceDetect(e.data.img);
			break;
	}
}

self.onerror = function (e) {
	console.log(e);
}
