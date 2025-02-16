import * as THREE from 'three';
import vertexShader from './shaders/vertex.glsl';
import fragmentShader from './shaders/fragment.glsl';
import { OrbitControls } from 'three/examples/jsm/Addons.js';

class App {
  private scene: THREE.Scene;
  private camera: THREE.PerspectiveCamera;
  private renderer: THREE.WebGLRenderer;
  private geometry: THREE.PlaneGeometry;
  private material: THREE.ShaderMaterial;
  private mesh: THREE.Mesh;
  private startTime: number;

  private controls: OrbitControls; // Declare controls

  private camConfig = {
    fov: 75,
    aspect: window.innerWidth / window.innerHeight,
    near: 0.1,
    far: 1000,
  };

  constructor() {
    // Create scene
    this.scene = new THREE.Scene();

    // Setup camera
    this.camera = new THREE.PerspectiveCamera(
      this.camConfig.fov,
      this.camConfig.aspect,
      this.camConfig.near,
      this.camConfig.far
    );

    // Setup renderer
    this.renderer = new THREE.WebGLRenderer({
      antialias: true,
      powerPreference: 'high-performance',
    });
    if (!this.renderer.capabilities.isWebGL2) {
      console.warn('WebGL 2.0 is not available on this browser.');
    }
    this.renderer.setSize(720, 720);
    document.body.appendChild(this.renderer.domElement);

    const resolution = new THREE.Vector2(window.innerWidth, window.innerHeight);

    // Create shader material
    this.geometry = new THREE.PlaneGeometry(2, 2);
    this.material = new THREE.RawShaderMaterial({
      vertexShader,
      fragmentShader,
      uniforms: {
        projectionMatrix: { value: this.camera.projectionMatrix },
        viewMatrix: { value: this.camera.matrixWorldInverse },
        modelMatrix: { value: new THREE.Matrix4() },
        u_time: { value: 0.0 },
        u_resolution: { value: resolution },
        roughnessFactor: { value: 0.5 },
        color: { value: new THREE.Color(0xff0000) },
        u_cameraPosition: { value: new THREE.Vector3() }
      },
      glslVersion: THREE.GLSL3,
    });

    // Create mesh
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
    this.camera.position.z = 1.5;

    // Initialize
    this.startTime = Date.now();
    this.onWindowResize();

    // Add OrbitControls for mouse interaction
    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true; // Smooth damping
    this.controls.dampingFactor = 0.25; // Damping speed
    this.controls.screenSpacePanning = false; // Prevent panning to go out of view

    // Bind methods
    this.onWindowResize = this.onWindowResize.bind(this);
    this.animate = this.animate.bind(this);

    // Add event listeners
    window.addEventListener('resize', this.onWindowResize);
    window.addEventListener('keydown', this.onKeyDown.bind(this)); // Listen for arrow keys

    // Start the main loop
    this.animate();
  }

  private animate(): void {
    requestAnimationFrame(this.animate);
    const elapsedTime = (Date.now() - this.startTime) / 1000;
    this.material.uniforms.u_time.value = elapsedTime;

    // Update camera position
    this.material.uniforms.u_cameraPosition.value.copy(this.camera.position);

    // Update OrbitControls
    this.controls.update(); 

    this.renderer.render(this.scene, this.camera);
  }

  private onWindowResize(): void {
    this.camera.aspect = this.camConfig.aspect;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    this.material.uniforms.u_resolution.value.set(window.innerWidth, window.innerHeight);
  }

  // Handle arrow keys for camera movement
  private onKeyDown(event: KeyboardEvent): void {
    const moveSpeed = 0.1; // Camera movement speed
    switch (event.key) {
      case 'ArrowUp':
        this.camera.position.z -= moveSpeed;
        break;
      case 'ArrowDown':
        this.camera.position.z += moveSpeed;
        break;
      case 'ArrowLeft':
        this.camera.position.x -= moveSpeed;
        break;
      case 'ArrowRight':
        this.camera.position.x += moveSpeed;
        break;
    }
  }
}

const myApp = new App();
