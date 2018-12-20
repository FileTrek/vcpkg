include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO FileTrek/avro
  REF 9b9182e87c6c6cf1760bea6e3d533064f5be5e79
  SHA512 ea416f299b857683074f6745affd1def1da1f00e9350b74f458b730a01426fae202d4192e69e52213f12ce2e3db370802f4c029c50158c6473061b88856eac35
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
