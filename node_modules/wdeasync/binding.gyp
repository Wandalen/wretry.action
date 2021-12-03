{
  "targets":
  [
    {
      "target_name": "deasync",
      "cflags!": [ "-fno-exceptions" ],
      "cflags_cc!": [ "-fno-exceptions" ],
      "xcode_settings":
      { "GCC_ENABLE_CPP_EXCEPTIONS": "YES",
        "CLANG_CXX_LIBRARY": "libc++",
        "MACOSX_DEPLOYMENT_TARGET": "10.7",
      },
      "msvs_settings":
      {
        "VCCLCompilerTool": { "ExceptionHandling": 1 },
      },
      "sources":
      [
        "cpp/deasync.cc"
      ],
      "include_dirs":
      [
        "<!@(node -p \"require('node-addon-api').include\")",
      ]
    },
    {
      "target_name": "action_after_build",
      "type": "none",
      "dependencies": [ "<(module_name)" ],
      "copies":
      [
        {
            "files": [ "<(PRODUCT_DIR)/<(module_name).node" ],
            "destination": "<(module_path)"
        }
      ]
    }
  ]
}
