#!/usr/bin/env python3
"""
Simple compliance report generator for Helm-based Terraform modules.
This is a minimal implementation since ESO modules don't use traditional AWS compliance checks.
"""

import json
import argparse
import os

def generate_report(results_dir, format_type, output_file):
    """Generate a simple compliance report for Helm modules."""
    
    # Load Checkov results if available
    checkov_file = os.path.join(results_dir, 'checkov-results.json')
    checkov_data = {"summary": {"passed": 0, "failed": 0, "skipped": 0}}
    
    if os.path.exists(checkov_file):
        with open(checkov_file, 'r') as f:
            checkov_data = json.load(f)
    
    if format_type == 'markdown':
        generate_markdown_report(checkov_data, output_file)
    elif format_type == 'json':
        generate_json_report(checkov_data, output_file)

def generate_markdown_report(checkov_data, output_file):
    """Generate markdown compliance report."""
    summary = checkov_data.get('summary', {})
    passed = summary.get('passed', 0)
    failed = summary.get('failed', 0)
    skipped = summary.get('skipped', 0)
    
    report = f"""# Compliance Report - External Secrets Operator Module

## Summary

This module deploys Helm charts and Kubernetes resources, not traditional AWS infrastructure.
Most AWS-specific compliance checks are not applicable.

## Results

| Check Type | Count |
|------------|-------|
| ✅ Passed | {passed} |
| ❌ Failed | {failed} |
| ⏭️ Skipped | {skipped} |

## Compliance Status

{'✅ **COMPLIANT**' if failed == 0 else '⚠️ **REVIEW REQUIRED**'}

## Notes

- This module deploys External Secrets Operator via Helm
- AWS resource security checks are not applicable to Kubernetes operators
- Compliance focuses on Terraform structure and basic security practices
"""

    with open(output_file, 'w') as f:
        f.write(report)

def generate_json_report(checkov_data, output_file):
    """Generate JSON compliance report."""
    summary = checkov_data.get('summary', {})
    
    report = {
        "module_type": "helm-kubernetes",
        "compliance_framework": "terraform-basic",
        "summary": summary,
        "status": "compliant" if summary.get('failed', 0) == 0 else "review_required",
        "notes": "Helm-based module with limited AWS compliance scope"
    }
    
    with open(output_file, 'w') as f:
        json.dump(report, f, indent=2)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate compliance report for Helm modules')
    parser.add_argument('--results-dir', required=True, help='Directory containing scan results')
    parser.add_argument('--format', choices=['markdown', 'json'], required=True, help='Output format')
    parser.add_argument('--output', required=True, help='Output file path')
    
    args = parser.parse_args()
    generate_report(args.results_dir, args.format, args.output)
