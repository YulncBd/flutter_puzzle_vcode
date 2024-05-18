## flutter_puzzle_vcode

![](/example/assets/demo.gif)

# Using
add flutter_puzzle_vcode to your pubspec.yaml file:

```yaml
dependencies:
sliver_grid_view: ^latest
```

import sliver_grid_view file that it will bu used:
```dart
import 'package:flutter_puzzle_vcode/flutter_puzzle_vcode.dart';
```

there is a example to help you
```dart
   showDialog(
     context: context,
     builder: (BuildContext context) {
        return FlutterPuzzleVCode(onSuccess: (){
            Navigator.pop(context);
        },);
     });
```
