# Realizing Robotic Swimming with Unified Fluid-Robot Multiphysics

Project page for the RSS 2026 submission.

**[Project page](#) · [Paper](#) · [arXiv](#) · [Code](#) · [Video](#)**

> Replace the `#` placeholders above with real URLs after the page goes live.

## Authors

Jeong Hun Lee\*, Junzhe Hu\*, Sofia Kwok, Carmel Majidi, Zachary Manchester
Carnegie Mellon University · \*equal contribution

## TL;DR

We pose fluid-robot multiphysics as a **single least-action optimization** rather than two separately-integrated physics that are coupled through a force term. Discretizing the unified action with variational mechanics and a new integral-form immersed-boundary constraint yields a differentiable simulator that transfers undulatory swimming and a gradient-optimized C-start escape to an untethered eel robot.

## Citation

```bibtex
@inproceedings{lee2026realizing,
  title     = {Realizing Robotic Swimming with Unified Fluid-Robot Multiphysics},
  author    = {Lee, Jeong Hun and Hu, Junzhe and Kwok, Sofia and Majidi, Carmel and Manchester, Zachary},
  booktitle = {Robotics: Science and Systems (RSS)},
  year      = {2026}
}
```

## Local development

The project page is a single static `index.html`. To preview locally:

```bash
python3 -m http.server 8000
# then open http://localhost:8000
```

## Acknowledgments

Page design borrows structure from the [Nerfies project page](https://nerfies.github.io/).
