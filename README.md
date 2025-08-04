# PathObjectsPlacer

A custom Godot 4 Node3D tool for placing objects along a Path3D with precise spacing and positioning controls.
Inspired by Object String feature in X-Plane flight sim, decided to do the same for Godot for quick prototyping.
Initial idea was placing lamp posts, traffic lights, signs, trees etc. along the roads, quickly creating fence, etc.
Use with Godot version 4.4, earlier versions not suuported yet. Please write in Issues if you need such a support.

## Features

- Place objects at regular intervals along any Path3D
- Control spacing between objects
- Place objects on both left and right sides of the path
- Adjust vertical and horizontal offsets from the path
- Rotate objects around their vertical axis
- Choose between path-relative or absolute up vectors
- Real-time updates when parameters change
- Tool button for manual refresh

## Installation
### Manual
Checkout/download this repo, copy "addons/" folder to the root directory of your project

## Usage

1. Create a Path3D in your scene
2. Add the PathObjectsPlacer as a child node
3. Assign a scene containing object to be placed, like tree or lamp post, to the `item` property
4. Configure the placer properties in the inspector

## Properties

| Property | Description |
|----------|-------------|
| **item** | PackedScene to place along the path (required) |
| **item_distance** | Distance between placed objects (in meters) |
| **from_dist** | Starting position along the path (in meters) |
| **to_dist** | Ending position along the path (-1 for full length) |
| **left** | Place objects on the left side of the path |
| **right** | Place objects on the right side of the path |
| **distance_from_center** | Horizontal offset from path center |
| **distance_up** | Vertical offset from path |
| **obj_rotation** | Rotation around vertical axis (degrees) |
| **absolute_up** | Use world up vector instead of path normal |

## Tips

- The placer automatically updates when properties change in the editor
- Not 100% well tested, if scene wan't updated properly - please use the "Refresh" button in the inspector to manually update placements
- Combine with other nodes for complex path-based systems
- Works great for placing fences, street lamps, or other repeating elements
- From Dist and To Dist could be used if you e.g. need to make fence along the road, but need to leave segment without fence to create road crossing

## Limitations

- Currently only works with immediate Path3D parent
- Complex rotations may need additional adjustment
- Performance may degrade with very dense placements

## License

[MIT License](LICENSE) - free to use in both open-source and commercial projects

## Usage exmple
![Usage GIF](./use00.gif)