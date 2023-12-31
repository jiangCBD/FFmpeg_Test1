# check if Xcode and CMake have the same understanding of Bundle layout

enable_language(C)

if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "")
  set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "tvOS" OR CMAKE_SYSTEM_NAME STREQUAL "visionOS" OR CMAKE_SYSTEM_NAME STREQUAL "watchOS")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO")
  set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "")
  set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "YES")
endif()

# App Bundle

add_executable(AppBundle MACOSX_BUNDLE main.m)

add_custom_target(AppBundleTest ALL
  COMMAND ${CMAKE_COMMAND} -E copy
    "$<TARGET_FILE:AppBundle>" "$<TARGET_FILE:AppBundle>.old")

add_dependencies(AppBundleTest AppBundle)

# with custom extension

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  add_executable(AppBundleExt MACOSX_BUNDLE main.m)
  set_target_properties(AppBundleExt PROPERTIES BUNDLE_EXTENSION "foo")
  install(TARGETS AppBundleExt BUNDLE DESTINATION FooExtension)

  add_custom_target(AppBundleExtTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:AppBundleExt>" "$<TARGET_FILE:AppBundleExt>.old")

  add_dependencies(AppBundleExtTest AppBundleExt)
endif()

# Shared Framework (not supported for iOS on Xcode < 6)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "iOS" OR NOT XCODE_VERSION VERSION_LESS 6)
  add_library(SharedFramework SHARED main.c)
  set_target_properties(SharedFramework PROPERTIES FRAMEWORK TRUE)

  add_custom_target(SharedFrameworkTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_DIR:SharedFramework>" "$<TARGET_BUNDLE_DIR:SharedFramework>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_CONTENT_DIR:SharedFramework>" "$<TARGET_BUNDLE_CONTENT_DIR:SharedFramework>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:SharedFramework>" "$<TARGET_FILE:SharedFramework>.old")

  add_dependencies(SharedFrameworkTest SharedFramework)

  # with custom extension

  add_library(SharedFrameworkExt SHARED main.c)
  set_target_properties(SharedFrameworkExt PROPERTIES FRAMEWORK TRUE)
  set_target_properties(SharedFrameworkExt PROPERTIES BUNDLE_EXTENSION "foo")
  install(TARGETS SharedFrameworkExt FRAMEWORK DESTINATION FooExtension)

  add_custom_target(SharedFrameworkExtTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_DIR:SharedFrameworkExt>" "$<TARGET_BUNDLE_DIR:SharedFrameworkExt>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_CONTENT_DIR:SharedFrameworkExt>" "$<TARGET_BUNDLE_CONTENT_DIR:SharedFrameworkExt>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:SharedFrameworkExt>" "$<TARGET_FILE:SharedFrameworkExt>.old")

  add_dependencies(SharedFrameworkExtTest SharedFrameworkExt)
endif()

# Static Framework (not supported for Xcode < 6)

if(NOT XCODE_VERSION VERSION_LESS 6)
  add_library(StaticFramework STATIC main.c)
  set_target_properties(StaticFramework PROPERTIES FRAMEWORK TRUE)

  add_custom_target(StaticFrameworkTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_DIR:StaticFramework>" "$<TARGET_BUNDLE_DIR:StaticFramework>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_CONTENT_DIR:StaticFramework>" "$<TARGET_BUNDLE_CONTENT_DIR:StaticFramework>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:StaticFramework>" "$<TARGET_FILE:StaticFramework>.old")

  add_dependencies(StaticFrameworkTest StaticFramework)

  # with custom extension

  add_library(StaticFrameworkExt STATIC main.c)
  set_target_properties(StaticFrameworkExt PROPERTIES FRAMEWORK TRUE)
  set_target_properties(StaticFrameworkExt PROPERTIES BUNDLE_EXTENSION "foo")
  install(TARGETS StaticFrameworkExt FRAMEWORK DESTINATION StaticFooExtension)

  add_custom_target(StaticFrameworkExtTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_DIR:StaticFrameworkExt>" "$<TARGET_BUNDLE_DIR:StaticFrameworkExt>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_CONTENT_DIR:StaticFrameworkExt>" "$<TARGET_BUNDLE_CONTENT_DIR:StaticFrameworkExt>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:StaticFrameworkExt>" "$<TARGET_FILE:StaticFrameworkExt>.old")

  add_dependencies(StaticFrameworkExtTest StaticFrameworkExt)
endif()

# Bundle

if(NOT CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE)
  add_library(Bundle MODULE main.c)
  set_target_properties(Bundle PROPERTIES BUNDLE TRUE)

  add_custom_target(BundleTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_DIR:Bundle>" "$<TARGET_BUNDLE_DIR:Bundle>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_CONTENT_DIR:Bundle>" "$<TARGET_BUNDLE_CONTENT_DIR:Bundle>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:Bundle>" "$<TARGET_FILE:Bundle>.old")

  add_dependencies(BundleTest Bundle)

  # with custom extension

  add_library(BundleExt MODULE main.c)
  set_target_properties(BundleExt PROPERTIES BUNDLE TRUE)
  set_target_properties(BundleExt PROPERTIES BUNDLE_EXTENSION "foo")
  install(TARGETS BundleExt LIBRARY DESTINATION FooExtension)

  add_custom_target(BundleExtTest ALL
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_DIR:BundleExt>" "$<TARGET_BUNDLE_DIR:BundleExt>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_BUNDLE_CONTENT_DIR:BundleExt>" "$<TARGET_BUNDLE_CONTENT_DIR:BundleExt>.old"
    COMMAND ${CMAKE_COMMAND} -E copy
      "$<TARGET_FILE:BundleExt>" "$<TARGET_FILE:BundleExt>.old")

  add_dependencies(BundleExtTest BundleExt)
endif()
