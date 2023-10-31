### CMakeFetchKautilModule
* clone repository and build it. this is not comprehensive yet.
* althogh it is assumed module which is in Kautils, it can also be applied to other modules to a certain extent.
### note 
* the way to clone is currently fixed at 'init', 'fetch ... depth=1', then 'checkout' .  
* the default location is ${CMAKE_BINARY_DIR}/CMakeFetchKautilModule} 
* if you update all the module that CMakeFetchKautilModule can see in a configuration, use set(CMakeFetchKautilModule.force FALSE)  
    * CMakeFetchKautilModule will erase tree that it is managing (cloned by this module).  
    * then refetch repos of same id.
    * then build but if build tree remains, reuse that remain.

* argument1.CLONE_PREFIX : last cloned dir
* argument1.INSTALL_PREFIX : last installed dir

### usage 
* name c11_string_allocator
* GIT some_uri.git
* REMOTE origin  
* BRANCH | TAG | HASH : must specify one of BRANCH,TAG or HASH   
* CMAKE_CONFIGURE  : cmake -S [auto] -B [auto] [CMAKE_CONFIGURE] [CMAKE_CONFIGURE_MACRO]  
* CMAKE_CONFIGURE_MACRO : -S and -B -G ${CMAKE_GENERATOR} is automatically filled. it is possilbe to specify other options from here.
* CMAKE_BUILD_OPTION : cmake --build [auto] [CMAKE_BUILD_OPTION] 
* CMAKE_INSTALL_OPTION : cmake --install [auto] [CMAKE_INSTALL_OPTION] 
* DESTINATION : the directory this module uses. the default is ${CMAKE_BINARY_DIR}/CMakeFetchKautilModule 
* NON_VERSIONING : add destination the suffix of "non_versioning/[repository_name]/[short_hash]"   
* FORCE_UPDATE : force to clone and build
* FORCE_BUILD  : force to build
* VERBOSE

```cmake
CMakeFetchKautilModule(name
        GIT
        REMOTE 
        BRANCH | TAG | HASH
        [CMAKE_CONFIGURE]
        [CMAKE_CONFIGURE_MACRO]
        [DESTINATION]
        [NON_VERSIONING]
        [FORCE_UPDATE]
        [FORCE_BUILD]
        [VERBOSE]
        )
```


### example
```cmake
# force to refetch all the repo within this configure.
# this can be used when want to update entire repos or when repair unexpectedly erased binaries. 
set(CMakeFetchKautilModule.force FALSE) 

set(__dest ${CMAKE_BINARY_DIR}/dest)
set(number_thread 2)
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


# assume kautil_some_module generate target "kautil::some_module::version::static"
CMakeFetchKautilModule(
    kautil_some_module # expected to support KAUTIL_PROJECT_SUFFIX    
    GIT "C:/Users/ka/Downloads/test.org" 
    REMOTE origin 
    HASH ${${m}_commit_hash}
    PROJECT_SUFFIX some_suffix

    )
# if use PROJECT_SUFFIX then "kautil::some_module::version::static" become kautil::some_module::[PROJECT_SUFFIX]::static
# whcih will be found with find_package(KautilSomeModule.[PROJECT_SUFFIX].static)

set(${m}_commit_hash some_commit_hash)
CMakeFetchKautilModule(
    kautil_some_module # expected to support KAUTIL_PROJECT_SUFFIX    
    GIT "C:/Users/ka/Downloads/test.org" 
    REMOTE origin 
    HASH ${${m}_commit_hash}
    PROJECT_RENAME ${${m}_commit_hash}
    )

# if use PROJECT_SUFFIX then "kautil::some_module::version::static" become [PROJECT_SUFFIX]
# whcih will be found with find_package([PROJECT_RENAME])



```