{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    # userSettings = {
    #   "[javascript]" = {
    #     "editor.defaultFormatter" = "esbenp.prettier-vscode";
    #     "editor.formatOnSave" = true;
    #   };
    #   "[javascriptreact]" = {
    #     "editor.formatOnSave" = false;
    #   };
    #   "atlascode.bitbucket.explorer.enabled" = true;
    #   "atlascode.bitbucket.issues.explorerEnabled" = false;
    #   "atlascode.bitbucket.statusbar.enabled" = false;
    #   "atlascode.jira.enabled" = true;
    #   "atlascode.jira.jqlList" = [
    #     {
    #       "id" = "fa8cc694-d448-417b-934d-2548f2175342";
    #       "enabled" = true;
    #       "name" = "me";
    #       "query" = "project = \"CX\" AND status != Closed AND assignee = currentUser() AND Sprint in openSprints() ORDER BY statusCategory DESC";
    #       "siteId" = "88fe7a39-56cc-4591-8c0c-4bb802318829";
    #       "monitor" = true;
    #     }
    #   ];
    #   "atlascode.jira.statusbar.enabled" = false;
    #   "breadcrumbs.enabled" = false;
    #   "diffEditor.ignoreTrimWhitespace" = false;
    #   "diffEditor.renderSideBySide" = false;
    #   "editor.bracketPairColorization.enabled" = false;
    #   "editor.defaultFormatter" = "esbenp.prettier-vscode";
    #   "editor.fontFamily" = "Fira Code, Menlo, Monaco, 'Courier New', monospace";
    #   "editor.fontLigatures" = true;
    #   "editor.formatOnSave" = true;
    #   "editor.minimap.enabled" = false;
    #   "editor.renderWhitespace" = "all";
    #   "editor.tabSize" = 2;
    #   "emmet.includeLanguages" = {
    #     "javascript" = "javascriptreact";
    #   };
    #   "eslint.alwaysShowStatus" = true;
    #   "files.autoSave" = "onFocusChange";
    #   "files.trimTrailingWhitespace" = true;
    #   "git.autofetch" = true;
    #   "javascript.updateImportsOnFileMove.enabled" = "always";
    #   "prettier.requireConfig" = true;
    #   "projectManager.git.baseFolders" = [ "~/Developer/work" ];
    #   "security.workspace.trust.untrustedFiles" = "open";
    #   "telemetry.telemetryLevel" = "off";
    #   "terminal.integrated.defaultLocation" = "view";
    #   "terminal.integrated.defaultProfile.osx" = "fish";
    #   "terminal.integrated.fontFamily" = "Fira Mono for Powerline";
    #   "typescript.updateImportsOnFileMove.enabled" = "always";
    #   "workbench.colorTheme" = "Nord";
    #   "workbench.iconTheme" = "moxer-icons";
    #   "yaml.schemas" = {
    #     "file:///Users/alonzothomas/.vscode/extensions/atlassian.atlascode/resources/schemas/pipelines-schema.json" = "bitbucket-pipelines.yml";
    #   };
    # };
  };
}