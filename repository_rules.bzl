
def _switched_rules_impl(ctx):
    disabled_rule_script = """
def {rule_name}(**kwargs):
    pass
"""
    enabled_native_rule_script = """
{rule_name} = {native_rule_name}
"""
    enabled_rule_script = """
load("{file_label}", _{rule_name} = "{loaded_rule_name}")
"""
    elabled_rule_scrip_alias = """
{rule_name} = _{rule_name}
"""
    load_rules = []  # load() must go before everythin else in .bzl files since Bazel 0.25.0
    rules = []

    for rule_name, value_and_name in ctx.attr.rules.items():
        value = value_and_name[0]
        loaded_rule_name = value_and_name[1] if value_and_name[1] else rule_name

        if not value:
            rules.append(disabled_rule_script.format(rule_name = rule_name))
        elif value.startswith("@"):
            load_rules.append(enabled_rule_script.format(
                file_label = value,
                rule_name = rule_name,
                loaded_rule_name = loaded_rule_name,
            ))
            rules.append(elabled_rule_scrip_alias.format(rule_name = rule_name))
        elif value.startswith("native."):
            rules.append(
                enabled_native_rule_script.format(rule_name = rule_name, native_rule_name = value),
            )
        else:
            rules.append(value)

    ctx.file("BUILD.bazel", "")
    ctx.file("imports.bzl", "".join(load_rules + rules))

switched_rules = repository_rule(
    implementation = _switched_rules_impl,
    attrs = {
        "rules": attr.string_list_dict(
            allow_empty = True,
            mandatory = False,
            default = {},
        ),
    },
)

def switched_rules_by_language(
        name,
        rules_override = {}):

    rules = {}

    #
    # Common
    #
    rules["proto_library_with_info"] = _switch(
        True,
        "@rules_gapic//:gapic.bzl",
    )

    #
    # Java
    #
    rules["java_gapic_spring_library"] = _switch(
        True,
        "@spring_cloud_generator//:java_gapic_spring.bzl",
    )

    rules.update(rules_override)

    switched_rules(
        name = name,
        rules = rules,
    )

def _switch(enabled, enabled_value = "", actual_name = ""):
    if enabled:
        return [enabled_value, actual_name]
    else:
        return ["", actual_name]
