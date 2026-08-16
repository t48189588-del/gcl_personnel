## Vercel reservation website configuration
```
{
  "schema_version": "1.0",
  "document_type": "llm_troubleshooting_context",
  "last_updated": "2026-08-16",

  "project": {
    "name": "sharepoint_reservation_app",
    "type": "Flutter Web application",
    "purpose": "Public organization website/application connected to SharePoint and Excel through Power Automate",
    "repository": {
      "provider": "GitHub",
      "repository_contains_multiple_flutter_projects": true,
      "production_project_path": "sharepoint_reservation_app",
      "production_branch": "main"
    }
  },

  "technology_stack": {
    "frontend": {
      "framework": "Flutter",
      "flutter_version": "3.41.7",
      "dart_version": "3.11.5",
      "target": "Web",
      "build_command_local": "flutter build web",
      "build_output": "build/web"
    },

    "deployment": {
      "provider": "Vercel",
      "framework_preset": "Other",
      "root_directory": "sharepoint_reservation_app",
      "build_command": "./vercel-build.sh",
      "output_directory": "build/web",
      "install_command": "",
      "deployment_trigger": "GitHub push to main",
      "production_url_type": "Vercel default .vercel.app URL"
    },

    "backend": {
      "provider": "Vercel Functions",
      "language": "TypeScript",
      "function_directory": "api",
      "endpoints": [
        {
          "path": "/api/booking",
          "method": "POST",
          "purpose": "Retrieve booking/reservation data from SharePoint through Power Automate"
        },
        {
          "path": "/api/reservation",
          "method": "POST",
          "purpose": "Create/update reservation data in SharePoint through Power Automate"
        }
      ]
    },

    "external_services": {
      "automation": "Microsoft Power Automate",
      "data_sources": [
        "SharePoint",
        "Excel workbooks"
      ]
    }
  },

  "repository_structure": {
    "important": true,
    "description": "The GitHub repository contains another Flutter project at the repository root. The production website is inside sharepoint_reservation_app.",
    "structure": {
      "repository_root": {
        "contains": [
          "pubspec.yaml",
          "lib/",
          "web/",
          "android/",
          "ios/",
          "linux/",
          "macos/",
          "windows/"
        ],
        "note": "This is NOT the Vercel production application."
      },

      "sharepoint_reservation_app": {
        "contains": [
          "pubspec.yaml",
          "pubspec.lock",
          "lib/",
          "web/",
          "api/",
          "build/",
          "vercel.json",
          "vercel-build.sh",
          "package.json",
          "package-lock.json"
        ],
        "is_production_application": true
      }
    }
  },

  "vercel_configuration": {
    "root_directory": "sharepoint_reservation_app",
    "framework_preset": "Other",
    "build_command": "./vercel-build.sh",
    "output_directory": "build/web",
    "install_command": "",
    "vercel_json": {
      "$schema": "https://openapi.vercel.sh/vercel.json",
      "buildCommand": "./vercel-build.sh",
      "outputDirectory": "build/web"
    }
  },

  "flutter_build": {
    "expected_command": "flutter build web --release",
    "expected_output": "build/web/index.html",
    "local_build_verified": true,
    "vercel_build_verified": true,
    "notes": [
      "The Flutter application builds successfully.",
      "build/web is generated during deployment and should not need to be committed to Git.",
      "The Vercel deployment must build Flutter before deploying the output."
    ]
  },

  "vercel_build_script": {
    "filename": "vercel-build.sh",
    "purpose": "Install the required Flutter SDK and build the Flutter Web application inside Vercel",
    "expected_behavior": [
      "Install or obtain Flutter 3.41.7",
      "Add Flutter to PATH",
      "Enable Flutter Web",
      "Run flutter pub get",
      "Run flutter build web --release",
      "Produce build/web"
    ],
    "important": "The exact current contents of vercel-build.sh should be checked if deployment fails."
  },

  "node_configuration": {
    "package_json_exists": true,
    "purpose": "Provide Node/TypeScript dependencies required by Vercel Functions",
    "expected_dependencies": {
      "typescript": "5.9.x",
      "@types/node": "24.x"
    },
    "important": "Flutter dependencies remain managed by pubspec.yaml. package.json is only for the Vercel/TypeScript side."
  },

  "environment_variables": {
    "exists_in_vercel": true,
    "variables": [
      {
        "name": "POWER_AUTOMATE_URL_GET",
        "type": "secret",
        "purpose": "Power Automate POST endpoint used to retrieve data from SharePoint",
        "http_method_to_power_automate": "POST",
        "value_should_never_be_shared_with_an_llm": true
      },
      {
        "name": "POWER_AUTOMATE_URL_POST",
        "type": "secret",
        "purpose": "Power Automate POST endpoint used to push/create/update data in SharePoint",
        "http_method_to_power_automate": "POST",
        "value_should_never_be_shared_with_an_llm": true
      }
    ],
    "security_model": {
      "power_automate_urls_should_remain_server_side": true,
      "flutter_browser_should_call": [
        "/api/booking",
        "/api/reservation"
      ],
      "flutter_browser_should_not_directly_call_power_automate": true
    }
  },

  "api_architecture": {
    "flow": [
      "Browser",
      "Flutter Web",
      "Vercel Function",
      "Power Automate",
      "SharePoint or Excel"
    ],

    "booking": {
      "browser_request": "POST /api/booking",
      "vercel_environment_variable": "POWER_AUTOMATE_URL_GET",
      "outbound_request_method": "POST",
      "destination": "Power Automate",
      "purpose": "Retrieve data"
    },

    "reservation": {
      "browser_request": "POST /api/reservation",
      "vercel_environment_variable": "POWER_AUTOMATE_URL_POST",
      "outbound_request_method": "POST",
      "destination": "Power Automate",
      "purpose": "Push reservation data"
    }
  },

  "api_error_handling": {
    "missing_environment_variable": {
      "http_status": 500,
      "message": "Server configuration error"
    },

    "power_automate_failure": {
      "http_status": 502,
      "message": "Failed to contact booking/reservation service"
    },

    "unsupported_method": {
      "http_status": 405,
      "message": "Method not allowed"
    }
  },

  "historical_problem": {
    "problem": "Vercel deployment initially showed a 404 for the entire website after local terminal was closed",
    "initial_symptoms": [
      "Vercel deployment appeared to complete",
      "Default Vercel URL initially appeared to work",
      "Afterward the entire website returned 404",
      "No subdomains were involved"
    ],

    "root_causes": [
      "Vercel Root Directory initially needed to point to sharepoint_reservation_app",
      "Flutter was not being built during the Vercel deployment",
      "Vercel had an outputDirectory of build/web but no build command generating that directory",
      "Vercel TypeScript functions lacked Node type definitions"
    ],

    "diagnostic_log_before_fix": [
      "Running vercel build",
      "Using built-in TypeScript",
      "api/booking.ts: Cannot find name 'process'",
      "api/reservation.ts: Cannot find name 'process'",
      "Build Completed in /vercel/output [1s]",
      "Deploying outputs...",
      "Deployment completed",
      "Skipping cache upload because no files were prepared"
    ],

    "interpretation": "The deployment infrastructure completed but there were no frontend output files because Flutter had not been built."
  },

  "solution_applied": {
    "root_directory": {
      "old": "blank",
      "new": "sharepoint_reservation_app"
    },

    "framework_preset": "Other",

    "build_process": {
      "old": "blank",
      "new": "./vercel-build.sh"
    },

    "output_directory": {
      "old": "blank or configured only in a way that did not produce files",
      "new": "build/web"
    },

    "flutter_build": {
      "implemented": true,
      "command": "flutter build web --release"
    },

    "node_typescript": {
      "implemented": true,
      "package_json_created": true,
      "node_types_installed": true
    },

    "api_booking": {
      "handler_was_standardized": true
    }
  },

  "successful_deployment_log_characteristics": {
    "important_lines": [
      "Resolving dependencies...",
      "Got dependencies!",
      "Downloading Web SDK...",
      "Compiling lib/main.dart for the Web...",
      "✓ Built build/web",
      "Using TypeScript 5.9.3 (local user-provided)",
      "Build Completed in /vercel/output",
      "Deploying outputs..."
    ],

    "success_indicator": "✓ Built build/web",
    "important_difference_from_failed_deployment": "The successful deployment actually generates build/web before Vercel deploys outputs."
  },

  "non_fatal_build_messages": {
    "flutter_dependency_updates": {
      "severity": "informational",
      "action": "Do not upgrade automatically during troubleshooting."
    },

    "flutter_root_warning": {
      "message": "Woah! You appear to be trying to run flutter as root.",
      "severity": "warning",
      "impact_on_current_deployment": "No known impact; build still succeeds."
    },

    "wasm_dry_run": {
      "severity": "informational",
      "action": "Do not switch to Wasm unless there is a specific reason."
    },

    "tree_shaking": {
      "severity": "informational",
      "action": "Normal Flutter release optimization."
    }
  },

  "known_good_state": {
    "local_flutter_build": true,
    "vercel_flutter_build": true,
    "vercel_deployment": true,
    "public_website": "stable",
    "terminal_required_for_public_site": false,
    "github_to_vercel_deployment": true
  },

  "troubleshooting_order": [
    {
      "priority": 1,
      "check": "Is Vercel Root Directory set to sharepoint_reservation_app?"
    },
    {
      "priority": 2,
      "check": "Does Vercel execute ./vercel-build.sh?"
    },
    {
      "priority": 3,
      "check": "Does the build log contain ✓ Built build/web?"
    },
    {
      "priority": 4,
      "check": "Does build/web/index.html exist after the build?"
    },
    {
      "priority": 5,
      "check": "Does Vercel report that output files were deployed?"
    },
    {
      "priority": 6,
      "check": "Do TypeScript functions compile without process/type errors?"
    },
    {
      "priority": 7,
      "check": "Are POWER_AUTOMATE_URL_GET and POWER_AUTOMATE_URL_POST configured in the correct Vercel environment?"
    },
    {
      "priority": 8,
      "check": "Can POST /api/booking be reached?"
    },
    {
      "priority": 9,
      "check": "Can POST /api/reservation be reached?"
    },
    {
      "priority": 10,
      "check": "If APIs fail, inspect Vercel Function logs and Power Automate response."
    }
  ],

  "critical_diagnostic_rules": [
    {
      "symptom": "Entire website returns Vercel 404",
      "first_checks": [
        "Root Directory",
        "Build Command",
        "Output Directory",
        "Presence of build/web/index.html",
        "Vercel deployment output files"
      ],
      "do_not_start_with": "Power Automate or API debugging"
    },
    {
      "symptom": "Website loads but API returns 500",
      "first_checks": [
        "Vercel environment variables",
        "Function logs",
        "process.env variable names"
      ]
    },
    {
      "symptom": "Website loads but API returns 502",
      "first_checks": [
        "Power Automate availability",
        "Power Automate URL",
        "Power Automate HTTP response",
        "Request body format"
      ]
    },
    {
      "symptom": "Local Flutter works but Vercel fails",
      "first_checks": [
        "Flutter version used by Vercel",
        "Flutter build command",
        "Vercel working directory",
        "pubspec dependencies",
        "build/web output"
      ]
    }
  ],

  "security_rules_for_llm": [
    "Never request or reproduce the values of POWER_AUTOMATE_URL_GET or POWER_AUTOMATE_URL_POST.",
    "Never expose Vercel environment variable values in troubleshooting output.",
    "Never put Power Automate secret URLs into Flutter Web source or compiled client configuration.",
    "Treat anything embedded in Flutter Web as publicly inspectable.",
    "Use Vercel server-side functions as the security boundary for Power Automate URLs.",
    "If secrets are accidentally pasted into an LLM conversation, recommend rotating them."
  ],

  "debugging_commands": {
    "local_flutter": [
      "cd sharepoint_reservation_app",
      "flutter clean",
      "flutter pub get",
      "flutter build web --release"
    ],

    "local_typescript": [
      "cd sharepoint_reservation_app",
      "npm install",
      "npx tsc --noEmit"
    ],

    "git": [
      "git status",
      "git diff",
      "git log --oneline -10"
    ],

    "expected_flutter_output": "build/web/index.html"
  },

  "deployment_strategy": {
    "preferred": "GitHub push to main triggers Vercel production deployment",
    "avoid_as_primary_workflow": "Manual vercel --prod from local computer",
    "reason": "Production should be reproducible independently of the developer's local terminal or computer."
  },

  "future_troubleshooting_request_template": {
    "instruction_to_llm": "Use this context to troubleshoot the SharePoint Reservation Flutter Web application. Do not assume the original 404 problem still exists. First identify whether the failure is frontend deployment, Vercel Function execution, environment variables, Power Automate, or SharePoint/Excel.",
    "provide_to_llm": [
      "Current error message",
      "Exact URL/path that fails",
      "Whether the Flutter homepage loads",
      "Whether the failure occurs locally or only on Vercel",
      "Latest Vercel deployment status",
      "Relevant Vercel build/function logs",
      "Relevant browser console error",
      "Relevant browser Network request status"
    ]
  }
}
```