load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_pkg",
    sha256 = "8a298e832762eda1830597d64fe7db58178aa84cd5926d76d5b744d6558941c2",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
    ],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

http_archive(
    name = "com_google_protobuf",
    sha256 = "0b0395d34e000f1229679e10d984ed7913078f3dd7f26cf0476467f5e65716f4",
    strip_prefix = "protobuf-23.2",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v23.2.tar.gz"],
)
load("@com_google_protobuf//:protobuf_deps.bzl", "PROTOBUF_MAVEN_ARTIFACTS", "protobuf_deps")
protobuf_deps()

load("//:repository_rules.bzl", "switched_rules_by_language")
switched_rules_by_language(
    name = "com_google_googleapis_imports",
)

### Setup rules_jvm_external

RULES_JVM_EXTERNAL_TAG = "2.6"
#RULES_JVM_EXTERNAL_TAG = "6.0"

RULES_JVM_EXTERNAL_SHA = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6"
#RULES_JVM_EXTERNAL_SHA = "85fd6bad58ac76cc3a27c8e051e4255ff9ccd8c92ba879670d195622e7c0a9b7"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")

### Setup rules_gapic
_rules_gapic_version = "1.0.0"

http_archive(
    name = "rules_gapic",
    strip_prefix = "rules_gapic-%s" % _rules_gapic_version,
    urls = ["https://github.com/googleapis/rules_gapic/archive/v%s.tar.gz" % _rules_gapic_version],
)

### Java-specific rules

_spring_cloud_generator_version = "5.0.1" # {x-version-update:spring-cloud-gcp:current}
_gapic_generator_java_version = "2.32.0"

maven_install(
    artifacts = [
        "com.google.cloud:spring-cloud-generator:" + _spring_cloud_generator_version,
    ],
    #Update this False for local development
    fail_on_missing_checksum = False,
    repositories = [
        "m2Local",
        "https://repo.maven.apache.org/maven2/",
    ]
)

local_repository(
    name = "spring_cloud_generator",
    path = "../../spring-cloud-generator",
)

http_archive(
    name = "gapic_generator_java",
    strip_prefix = "sdk-platform-java-%s" % _gapic_generator_java_version,
    urls = ["https://github.com/googleapis/sdk-platform-java/archive/v%s.zip" % _gapic_generator_java_version],
)

# gax-java is part of sdk-platform-java repository
http_archive(
    name = "com_google_api_gax_java",
    strip_prefix = "sdk-platform-java-%s/gax-java" % _gapic_generator_java_version,
    urls = ["https://github.com/googleapis/sdk-platform-java/archive/v%s.zip" % _gapic_generator_java_version],
)

load("@com_google_api_gax_java//:repository_rules.bzl", "com_google_api_gax_java_properties")

com_google_api_gax_java_properties(
    name = "com_google_api_gax_java_properties",
    file = "@com_google_api_gax_java//:dependencies.properties",
)

load("@com_google_api_gax_java//:repositories.bzl", "com_google_api_gax_java_repositories")

com_google_api_gax_java_repositories()
