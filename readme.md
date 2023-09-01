### CMakeFetchKautilModule
* clone repository and build it. this is not comprehensive yet.
* althogh it is assumed module which is in Kautils, it can also be applied to other modules to a certain extent.
* the way to clone is currently fixed at 'init', 'fetch ... depth=1', then 'checkout' .  
```cmake


# force to refetch all the repo within this configure.
# this can be used when want to update entire repos or when repair unexpectedly erased binaries. 
set(CMakeFetchKautilModule.force FALSE) 


# used as working directory. as default, clone ,build,install into here.     
# the default location is ${CMAKE_BINARY_DIR}/CMakeFetchKautilModule} 
set(__dest ${CMAKE_BINARY_DIR}/dest)

# the number of thread 
set(number_thread 2)
CMakeFetchKautilModule(c11_string_allocator
        GIT https://github.com/kautils/c11_string_allocator.git 
        REMOTE origin 
        TAG v0.0.1
        CMAKE_CONFIGURE_OPTION -DSOME="SOME" # -S and -B is automatically filled. it is possilbe to specify other options from here.
        CMAKE_BUILD_OPTION -j ${number_thread}
        CMAKE_INSTALL_OPTION --prefix ${CMAKE_BINARY_DIR}/test
        DESTINATION "${__dest}"
        #FORCE_UPDATE
        #VERBOSE
        )

CMakeFetchKautilModule(c11_string_allocator
        GIT https://github.com/kautils/c11_string_allocator.git 
        REMOTE origin 
        HASH bb0c08f47366b3bb6dd940bb0eaa9071be6955d9
        CMAKE_BUILD_OPTION -j ${number_thread}
        )

CMakeFetchKautilModule(split_view_iterator
        GIT https://github.com/kautils/split_view_iterator.git 
        REMOTE origin 
        BRANCH master
        CMAKE_BUILD_OPTION -j ${number_thread}
        )
```