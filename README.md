<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
	<a href="https://github.com/MoonGrt/SmartCarVision">
	<img src="images/logo.png" alt="Logo" width="80" height="80">
	</a>
<h3 align="center">SmartCarVision</h3>
	<p align="center">
	SmartCarVision is an FPGA-based intelligent car system that employs feature matching to recognize digits. Users can input a digit to the car, and if the camera detects that digit in its field of view, the car will follow the movement of that digit. Additionally, users can control the car's movement directly through Bluetooth connectivity.
	<br />
	<a href="https://github.com/MoonGrt/SmartCarVision"><strong>Explore the docs »</strong></a>
	<br />
	<a href="https://github.com/MoonGrt/SmartCarVision">View Demo</a>
	·
	<a href="https://github.com/MoonGrt/SmartCarVision/issues">Report Bug</a>
	·
	<a href="https://github.com/MoonGrt/SmartCarVision/issues">Request Feature</a>
	</p>
</div>


<!-- CONTENTS -->
<details open>
  <summary>Contents</summary>
  <ol>
    <li><a href="#file-tree">File Tree</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>


<!-- FILE TREE -->
## File Tree

```
└─ Project
  ├─ car.xpr
  ├─ vivado.jou
  ├─ vivado.log
  ├─ /.Xil/
  ├─ /car.cache/
  ├─ /car.hw/
  ├─ /car.ip_user_files/
  ├─ /car.runs/
  ├─ /car.sim/
  ├─ /car.srcs/
  │ └─ /sources_1/
  │   └─ /new/
  │     ├─ ajxd.v
  │     ├─ binarization.v
  │     ├─ binarization1.v
  │     ├─ CAM_RECO.v
  │     ├─ car.v
  │     ├─ digital_recognition.v
  │     ├─ digital_tube.v
  │     ├─ digit_reco.v
  │     ├─ dither.v
  │     ├─ Filter_bit.v
  │     ├─ frame.v
  │     ├─ gauss1.v
  │     ├─ matrix3x3.v
  │     ├─ matrix_generate_3x3.v
  │     ├─ mid-value.v
  │     ├─ motor.v
  │     ├─ myram.v
  │     ├─ pingpang.v
  │     ├─ projection.v
  │     ├─ rgb2ycbcr.v
  │     ├─ sobel_edge_detector.v
  │     ├─ square_frame.v
  │     ├─ sr04.v
  │     ├─ test.v
  │     ├─ test1.v
  │     ├─ test2.v
  │     ├─ threshold.v
  │     ├─ top.v
  │     ├─ uart_recv.v
  │     ├─ uart_send.v
  │     ├─ vip.v
  │     ├─ /Camera_Interface/
  │     │ ├─ cmos_capture_RGB565.v
  │     │ ├─ i2c_OV7670_RGB565_config.v
  │     │ └─ i2c_timing_ctrl.v
  │     └─ /VGA_Interface/
  │       └─ VGA.v
  └─ /doc/

```


<!-- CONTRIBUTING -->
## Contributing
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.
If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
<p align="right">(<a href="#top">top</a>)</p>


<!-- LICENSE -->
## License
Distributed under the MIT License. See `LICENSE` for more information.
<p align="right">(<a href="#top">top</a>)</p>


<!-- CONTACT -->
## Contact
MoonGrt - 1561145394@qq.com
Project Link: [MoonGrt/](https://github.com/MoonGrt/)
<p align="right">(<a href="#top">top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments
* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)   
<p align="right">(<a href="#top">top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/MoonGrt/SmartCarVision.svg?style=for-the-badge
[contributors-url]: https://github.com/MoonGrt/SmartCarVision/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/MoonGrt/SmartCarVision.svg?style=for-the-badge
[forks-url]: https://github.com/MoonGrt/SmartCarVision/network/members
[stars-shield]: https://img.shields.io/github/stars/MoonGrt/SmartCarVision.svg?style=for-the-badge
[stars-url]: https://github.com/MoonGrt/SmartCarVision/stargazers
[issues-shield]: https://img.shields.io/github/issues/MoonGrt/SmartCarVision.svg?style=for-the-badge
[issues-url]: https://github.com/MoonGrt/SmartCarVision/issues
[license-shield]: https://img.shields.io/github/license/MoonGrt/SmartCarVision.svg?style=for-the-badge
[license-url]: https://github.com/MoonGrt/SmartCarVision/blob/master/LICENSE

