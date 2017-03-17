<!doctype html>
<html lang="en">
	<head>
		<link rel=stylesheet href="../css/index.css" />
		<script src="../js/three.js"></script>
		<script src="../js/OrbitControls.js"></script>
		<script src="../js/Detector.js"></script>
		<script src="../js/stats.min.js"></script>
	</head>
	<body>
		<div id="container"></div>
		<div id="info"><a href="http://threejs.org" target="_blank">three.js</a> webgl - vertex colors</div>
		<script type="text/javascript">
			if ( ! Detector.webgl ) Detector.addGetWebGLMessage();

            var container, stats;
            var camera, controls, scene, renderer;
            var pickingData = [], pickingTexture, pickingScene;
            var highlightBox;

            var mouse = new THREE.Vector2();
            var offset = new THREE.Vector3( 1, 1, 1 );

			var windowHalfX = window.innerWidth / 2;
			var windowHalfY = window.innerHeight / 2;

			init();
			animate();

			function init() {

				container = document.getElementById( 'container' );
				
				//Camera
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 0.1, 20000 );
				camera.position.z = 1800;

				//Init two scenes, one for displaying, second for picking
                scene = new THREE.Scene();
                pickingScene = new THREE.Scene();
                pickingTexture = new THREE.WebGLRenderTarget( window.innerWidth, window.innerHeight );
                pickingTexture.texture.minFilter = THREE.LinearFilter;
                scene.add( new THREE.AmbientLight( 0x555555 ) );

				//Add two lights to scene, one in front, second in the back
                var light = new THREE.SpotLight( 0xffffff, 1.5 );
                light.position.set( 500, 0, 1000);
                scene.add( light );
                var light1 = new THREE.SpotLight( 0xffffff, 1.5 );
				light1.position.set( -500, 0, -1000);
                scene.add( light1 );

				//Load map
                var loader = new THREE.TextureLoader();
                var floorTexture = loader.load( 'images/map.jpg' );
                var floorMaterial = new THREE.MeshBasicMaterial( { map: floorTexture, side: THREE.DoubleSide } );
                var floorGeometry = new THREE.PlaneBufferGeometry( 1000, 1000, 1, 1 );
                var floor = new THREE.Mesh(floorGeometry, floorMaterial);
                floor.position.y = 0;
                floor.rotation.x = 0;//-Math.PI / 2;
                scene.add(floor);

                var geometry = new THREE.Geometry(),
                	pickingGeometry = new THREE.Geometry(),
                    pickingMaterial = new THREE.MeshBasicMaterial( { color: 0xffffff, vertexColors: THREE.VertexColors } ),
                    defaultMaterial = new THREE.MeshPhongMaterial({ color: 0xffffff, shading: THREE.FlatShading, vertexColors: THREE.VertexColors, shininess: 0, opacity: 0.75,
                        transparent: true	});
                function applyVertexColors( g, c ) {

                    g.faces.forEach( function( f ) {

                        var n = ( f instanceof THREE.Face3 ) ? 3 : 4;
                        for( var j = 0; j < n; j ++ ) {
                            f.vertexColors[ j ] = c;
                        }
                    });
                }
                var geom = new THREE.BoxGeometry( 1, 1, 1 );
                var color = new THREE.Color();

                var matrix = new THREE.Matrix4();
                var quaternion = new THREE.Quaternion();
                var j = 0;
                for (var i = 0; i < 100; i++) {
                    for (var j = 0; j < 100; j++) {

                        var h = Math.floor((Math.random() * 60) - 30);

                        if(h != 0)
                            geom = new THREE.BoxGeometry(1,1,1);
                        else
                            geom = new THREE.BoxGeometry(0,0,0);

                        var position = new THREE.Vector3();
                        position.x = 10 * i - 495;
                        position.y = 10 * j - 495;
                        position.z = h > 0 ? h  / 2 + 2 : h / 2 - 2;

                        var rotation = new THREE.Euler();
                        rotation.x = 0;
                        rotation.y = 0;
                        rotation.z = 0;

                        var scale = new THREE.Vector3();
                        scale.x = 10;
                        scale.y = 10;
                        scale.z = h > 0 ? h : -h;

                        quaternion.setFromEuler( rotation, false );
                        matrix.compose( position, quaternion, scale );

                        if(h > 0)
							color.setHSL( 0.33, 1, 1 - h / 30 / 2 );
                        else
                            color.setHSL( 1, 1, 1 + h / 30 / 2 );

						applyVertexColors( geom, color );
						geometry.merge( geom, matrix );

						applyVertexColors( geom, color.setHex( i * 100 + j ) );
                        pickingGeometry.merge( geom, matrix );

                        pickingData[ i * 100 + j ] = {
                            position: position,
                            rotation: rotation,
                            scale: scale
                        };
                    }
                }

                var drawnObject = new THREE.Mesh( geometry, defaultMaterial );
                scene.add( drawnObject );

                pickingScene.add( new THREE.Mesh( pickingGeometry, pickingMaterial ) );

                highlightBox = new THREE.Mesh(
                    new THREE.BoxGeometry( 1, 1, 1 ),
                    new THREE.MeshLambertMaterial( { color: 0xffff00 }
                    ) );
                scene.add( highlightBox );

				renderer = new THREE.WebGLRenderer( { antialias: true } );
				renderer.setClearColor( 0xffffff );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( window.innerWidth, window.innerHeight );
                renderer.sortObjects = false;
				container.appendChild( renderer.domElement );

				stats = new Stats();
				//container.appendChild( stats.dom );

                renderer.domElement.addEventListener( 'mousemove', onMouseMove1 );

                controls = new THREE.OrbitControls( camera, renderer.domElement );

				document.addEventListener( 'click', onDocumentClick, false );
                //document.addEventListener( 'mousemove', onDocumentMouseMove, false );
				//window.addEventListener( 'resize', onWindowResize, false );
			}

            function onMouseMove1( e ) {

                mouse.x = e.clientX;
                mouse.y = e.clientY;
            }

			function onWindowResize() {

				windowHalfX = window.innerWidth / 2;
				windowHalfY = window.innerHeight / 2;

				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( window.innerWidth, window.innerHeight );
			}

			function onDocumentMouseMove( event ) {

				mouseX = ( event.clientX / window.innerWidth ) * 2 - 1;// = ( event.clientX - windowHalfX );
				mouseY = -( event.clientY / window.innerHeight ) * 2 + 1;//= ( event.clientY - windowHalfY );
			}

			function onDocumentClick( event ) {
			
				document.getElementById('info').innerHTML = 
				"X: " + highlightBox.position.x + ", Y: " + highlightBox.position.y + 
				"; Height: " + highlightBox.scale.z;
			}

			function animate() {

				requestAnimationFrame( animate );
				render();
				//FPS Counter
				stats.update();
			}

            function pick() {

                //render the picking scene off-screen
                renderer.render( pickingScene, camera, pickingTexture );

                //create buffer for reading single pixel
                var pixelBuffer = new Uint8Array( 4 );

                //read the pixel under the mouse from the texture
                renderer.readRenderTargetPixels(pickingTexture, mouse.x, pickingTexture.height - mouse.y, 1, 1, pixelBuffer);

                //interpret the pixel as an ID
                var id = ( pixelBuffer[0] << 16 ) | ( pixelBuffer[1] << 8 ) | ( pixelBuffer[2] );
                var data = pickingData[ id ];

                if (data) {

                    //move our highlightBox so that it surrounds the picked object
                    if ( data.position && data.rotation && data.scale ){

                        highlightBox.position.copy( data.position );
                        highlightBox.rotation.copy( data.rotation );
                        highlightBox.scale.copy( data.scale ).add( offset );
                        highlightBox.visible = true;
                    }
                } else {
                    highlightBox.visible = false;
                }
            }

			function render() {
                controls.update();
                pick();
                renderer.render( scene, camera );
			}
		</script>
	</body>
</html>
