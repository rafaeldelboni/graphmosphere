# graphmosphere

A Twitter Bot that create geometric pictures using Clojure + GraalVM.
https://twitter.com/graphmosphere

## Developing

### Update reflections definitions for GraalVM 
This will update the files in the folder `resources/META-INF/native-image`, they are reflection configuration files necessary for compiling the native-image.
If you have any problem while compiling the binary, you probably will need to run this again to update the files.
[Source](https://medium.com/graalvm/introducing-the-tracing-agent-simplifying-graalvm-native-image-configuration-c3b56c486271)

```bash
clojure -T:build ci
$GRAALVM_HOME/bin/java -agentlib:native-image-agent=config-output-dir=resources/META-INF/native-image,caller-filter-file=resources/META-INF/native-image/filter.json -jar target/graphmosphere-0.1.0-SNAPSHOT.jar
```

### Update `reflect-config.json`
After in the file `META-INF/native-image/reflect-config.json`, add the following entry:
```json
{
  "name": "java.lang.reflect.AccessibleObject",
  "methods" : [{"name":"canAccess"}]
},
```

And removes the following:
```json
{
  "name":"java.lang.reflect.Method",
  "methods":[{"name":"canAccess","parameterTypes":["java.lang.Object"] }]
},
```
[source](https://github.com/clj-easy/graal-docs#jdk11-and-clojurelangreflector)

## Usage

### Compile
Run the project's CI pipeline and build an uberjar and compile the native-image via graalvm:
```bash
./build-native.sh
```

### Run
This will generate an image and post it on twitter
```bash
./target/graphmosphere
```

## License
This is free and unencumbered software released into the public domain.  
For more information, please refer to <http://unlicense.org>
