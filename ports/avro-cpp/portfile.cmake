include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO apache/avro
  REF 1e5f62c8bd3b58d5d622d8abeb665d601c978f75
  SHA512 0d8f46285b6b94be955ba3b13269a0fa2aaee9ad702bf9b08db2e2b96a8533ee63b223ec88164da4192e5b1ba6c425d594c5fd18e55e106c6b8844a11d9c70ae
  HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/avro-cpp.patch)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/lang/c++
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DEBUG_POSTFIX=_d
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/lang/c++/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/avro-cpp RENAME copyright)

vcpkg_copy_pdbs()

# Install EXEs to the tools folder
file(GLOB EXES
        ${CURRENT_PACKAGES_DIR}/bin/avrogencpp.exe
    )
file(COPY ${EXES} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/avro-cpp)
# Tools require dlls
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/avro-cpp)
# Remove the EXEs from the bin folders
file(GLOB TO_REMOVE
        ${CURRENT_PACKAGES_DIR}/bin/avrogencpp.exe
        ${CURRENT_PACKAGES_DIR}/debug/bin/avrogencpp.exe)
file(REMOVE ${TO_REMOVE})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/avrocpp_s.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/avrocpp_s_d.lib)
