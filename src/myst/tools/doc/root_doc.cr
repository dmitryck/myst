require "yaml"

module Myst
  module Doc
    class RootDoc
      property kind = Kind::ROOT
      # These properties are meta information about the project being
      # documented. These are pulled from the `.mystdoc.yml` file in the
      # project's directory if one exists. Otherwise, they are mostly left nil.
      property project_name : String? = nil
      property version : String? = nil
      property homepage_url : String? = nil
      property logo_url : String? = nil
      property doc : String? = nil


      # These properties essentially mirror ModuleDoc and are generated by
      # the tool's scan of Myst source files.
      property submodules = {} of String => ModuleDoc
      property subtypes = {} of String => TypeDoc
      property constants = {} of String => ConstDoc
      property methods = {} of String => MethodDoc


      JSON.mapping(
        kind: Kind,
        project_name: {type: String?, emit_null: true},
        version: {type: String?, emit_null: true},
        homepage_url: {type: String?, emit_null: true},
        logo_url: {type: String?, emit_null: true},
        doc: {type: String?, emit_null: true},
        submodules: Hash(String, ModuleDoc),
        subtypes: Hash(String, TypeDoc),
        constants: Hash(String, ConstDoc),
        methods: Hash(String, MethodDoc)
      )

      YAML.mapping(
        project_name: String?,
        version: String?,
        homepage_url: String?,
        logo_url: String?,
        doc: String?
      )


      def initialize
      end
    end
  end
end