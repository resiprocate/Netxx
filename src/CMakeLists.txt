
set(INCLUDES
   ${CMAKE_SOURCE_DIR}/include/Netxx/Address.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Datagram.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/DatagramServer.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Netbuf.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Peer.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Probe.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/ProbeInfo.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/SockOpt.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Stream.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/StreamBase.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/StreamServer.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Timeout.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Types.h
   )

set(INCLUDES_TLS
   ${CMAKE_SOURCE_DIR}/include/Netxx/TLS/Certificate.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/TLS/Context.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/TLS/Stream.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Timeout.h
   ${CMAKE_SOURCE_DIR}/include/Netxx/Types.h
   )

set(INCLUDES_PVT
   Accept.h
   common.h
   compat.h
   inet6.h
   OSError.h
   Probe_impl.h
   RecvFrom.h
   Resolve.h
   ServerBase.h
   SockAddr.h
   Socket.h
   )

add_library(Netxx
   Accept.cxx
   Address.cxx
   Datagram.cxx
   DatagramServer.cxx
   OSError.cxx
   Peer.cxx
   Probe.cxx
   Probe_select.cxx
   RecvFrom.cxx
   Resolve_gethostbyname.cxx
   Resolve_getservbyname.cxx
   ServerBase.cxx
   SockAddr.cxx
   SockOpt.cxx
   Socket.cxx
   Stream.cxx
   StreamBase.cxx
   StreamServer.cxx
   ${INCLUDES}
   ${INCLUDES_PVT}
   )

target_add_conditional_sources(Netxx OPENSSL_FOUND
   TLS_Certificate.cxx
   TLS_Context.cxx
   TLS_Stream.cxx
   TLS_tls_pimpl.cxx
   TLS_cert_pimpl.h
   TLS_Context_pimpl.h
   TLS_tls_pimpl.h
   ${INCLUDES_TLS}
   )

set_target_properties(Netxx PROPERTIES SOVERSION 1)

target_include_directories(Netxx PUBLIC $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>)
target_link_libraries(Netxx PUBLIC ${OPENSSL_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

include(CMakePackageConfigHelpers)
configure_package_config_file(NetxxConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/NetxxConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/Netxx
  )
write_basic_package_version_file(
   ${CMAKE_CURRENT_BINARY_DIR}/NetxxConfigVersion.cmake
   VERSION ${CMAKE_PROJECT_VERSION}
   COMPATIBILITY SameMajorVersion
   )

install(TARGETS Netxx EXPORT NetxxTargets LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(EXPORT NetxxTargets
        FILE NetxxTargets.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/Netxx
)
#NAMESPACE Netxx::

install(FILES ${INCLUDES} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/Netxx)
install(FILES ${INCLUDES_TLS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/Netxx/TLS)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/NetxxConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/NetxxConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/Netxx)


