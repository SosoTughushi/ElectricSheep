#!/usr/bin/env node

/**
 * AI Article Writer - Main Entry Point
 * Generates articles with three difficulty levels about AI-first repositories and Cursor setup
 */

const fs = require('fs/promises');
const path = require('path');

// Parse command line arguments
function parseArgs() {
    const args = process.argv.slice(2);
    const parsed = {
        topic: '',
        output: './output/article.md',
        complexity: 'medium'
    };

    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--topic' && args[i + 1]) {
            parsed.topic = args[i + 1];
            i++;
        } else if (args[i] === '--output' && args[i + 1]) {
            parsed.output = args[i + 1];
            i++;
        } else if (args[i] === '--complexity' && args[i + 1]) {
            parsed.complexity = args[i + 1];
            i++;
        }
    }

    return parsed;
}

// Generate article content based on topic
function generateArticleContent(topic, complexity) {
    // For now, we'll generate content about AI-first repository setup
    // This will be expanded with actual AI-generated content later
    
    const article = {
        title: topic || 'Setting Up an AI-First Repository and Working with Cursor',
        sections: []
    };

    // Generate sections with three difficulty levels
    article.sections = generateSections(topic, complexity);

    return article;
}

// Generate article sections with complexity adaptation
function generateSections(topic, targetComplexity) {
    const sections = [];

    // Introduction section
    sections.push({
        title: 'Introduction',
        content: {
            simple: `Welcome! This guide will help you set up a repository that works great with AI assistants like Cursor. Think of it as organizing your code so AI can help you better.`,
            medium: `This guide covers setting up an AI-first repository structure optimized for AI-powered development tools like Cursor. We'll explore best practices for organizing code, documentation, and tooling to maximize AI assistant effectiveness.`,
            advanced: `An AI-first repository architecture optimizes code organization, documentation patterns, and tooling infrastructure to maximize the effectiveness of AI-powered development assistants. This guide examines architectural patterns, workflow optimizations, and integration strategies for Cursor and similar AI development environments.`
        }
    });

    // What is an AI-First Repository section
    sections.push({
        title: 'What is an AI-First Repository?',
        content: {
            simple: `An AI-first repository is a project organized so AI assistants can easily understand and help with it. It's like having a well-organized filing cabinet where everything has a clear label.`,
            medium: `An AI-first repository employs structured organization, comprehensive documentation, and standardized patterns that enable AI assistants to effectively understand, navigate, and contribute to the codebase. Key principles include self-documenting code, consistent naming conventions, and explicit metadata.`,
            advanced: `AI-first repository architecture applies information architecture principles to software development, creating codebases optimized for AI comprehension and manipulation. This involves semantic organization, explicit metadata systems (like MANIFEST.json), standardized tool interfaces, and documentation patterns that enable autonomous AI agent operation. The architecture prioritizes discoverability, predictability, and textual feedback loops over human-centric optimizations.`
        }
    });

    // Setting Up the Repository Structure section
    sections.push({
        title: 'Setting Up the Repository Structure',
        content: {
            simple: `Start by creating folders for different parts of your project. Put tools in a 'tools' folder, documentation in a 'docs' folder, and rules in a 'rules' folder. This helps AI find things quickly.`,
            medium: `Establish a clear directory hierarchy: \`tools/\` for executable tools organized by category, \`docs/\` for documentation, \`rules/\` for AI agent guidelines, and \`.toolset/\` for metadata. Each tool should include a MANIFEST.json with standardized metadata for AI discovery.`,
            advanced: `Implement a hierarchical directory structure following domain-driven design principles: \`tools/{category}/{tool-name}/\` with standardized subdirectories (\`scripts/\`, \`src/\`, \`docs/\`). Each tool requires a MANIFEST.json following the toolset schema, including id, description, parameters, and AI-friendly metadata. The \`.toolset/\` directory contains registry.json (tool inventory), operations.json (operation definitions), and configuration files. This structure enables programmatic tool discovery and execution.`
        }
    });

    // Working with Cursor section
    sections.push({
        title: 'Working with Cursor',
        content: {
            simple: `Cursor is an AI-powered code editor. To use it well, write clear comments in your code and organize files logically. Cursor's AI can then better understand what you're trying to do.`,
            medium: `Cursor leverages AI models to assist with code generation, refactoring, and navigation. Optimize for Cursor by maintaining clear code structure, comprehensive documentation, and consistent patterns. Use Cursor's rules system (\`.cursorrules\` files) to guide AI behavior and establish project-specific conventions.`,
            advanced: `Cursor integrates language models directly into the development workflow, enabling autonomous code generation and modification. Optimize Cursor effectiveness through: (1) structured rulesets in \`.cursorrules\` files with clear precedence hierarchies, (2) self-documenting code patterns that expose intent to AI models, (3) standardized tool interfaces enabling AI-driven tool discovery and execution, and (4) textual feedback loops where AI can verify its own work through command execution and output analysis. Configure Cursor rules following the project's rule precedence system (system > project > domain > tool).`
        }
    });

    // Best Practices section
    sections.push({
        title: 'Best Practices',
        content: {
            simple: `Keep things simple and organized. Write clear names for files and folders. Add comments explaining what your code does. Make sure your README file explains how to use your project.`,
            medium: `Follow these practices: (1) Use descriptive, consistent naming conventions, (2) Include MANIFEST.json files for all tools with complete metadata, (3) Maintain up-to-date README files with usage examples, (4) Document the "why" not just the "what", (5) Use standardized script interfaces, and (6) Keep documentation close to code.`,
            advanced: `Implement these architectural patterns: (1) Semantic versioning for tools and operations, (2) Operation codes (\`tool:operation\`) for programmatic tool invocation, (3) Structured error handling with parseable output formats, (4) Non-interactive command interfaces (use \`--yes\` flags), (5) Textual output for AI parsing (avoid binary formats), (6) Self-verification mechanisms enabling AI to validate its own changes, and (7) Privacy-aware design separating public (committed) from private (local config) data.`
        }
    });

    // Conclusion section
    sections.push({
        title: 'Conclusion',
        content: {
            simple: `Setting up an AI-first repository helps you work better with AI assistants. Start simple, keep things organized, and you'll see the benefits quickly!`,
            medium: `An AI-first repository structure significantly enhances productivity when working with AI development tools. By following these patterns and best practices, you create a codebase that AI assistants can effectively understand and contribute to.`,
            advanced: `AI-first repository architecture represents a paradigm shift toward codebases optimized for AI comprehension and manipulation. The investment in structured organization, comprehensive documentation, and standardized interfaces pays dividends in AI-assisted development velocity and quality. As AI development tools evolve, these architectural patterns will become increasingly critical for maintaining competitive development workflows.`
        }
    });

    return sections;
}

// Format article as Markdown
function formatArticle(article) {
    const now = new Date();
    const dateStr = now.toISOString().replace('T', ' ').substring(0, 19);

    let markdown = `---
title: ${article.title}
complexity: simple|medium|advanced
generated: ${dateStr}
---

# ${article.title}

> This article is available in three difficulty levels. Hover over paragraphs or use the complexity selector to switch between simple, medium, and advanced explanations.

`;

    article.sections.forEach((section, index) => {
        markdown += `## ${section.title}\n\n`;
        
        // Add all three complexity levels with annotations
        markdown += `<!-- simple:start -->\n`;
        markdown += `**Simple:** ${section.content.simple}\n\n`;
        markdown += `<!-- simple:end -->\n\n`;
        
        markdown += `<!-- medium:start -->\n`;
        markdown += `**Medium:** ${section.content.medium}\n\n`;
        markdown += `<!-- medium:end -->\n\n`;
        
        markdown += `<!-- advanced:start -->\n`;
        markdown += `**Advanced:** ${section.content.advanced}\n\n`;
        markdown += `<!-- advanced:end -->\n\n`;
        
        if (index < article.sections.length - 1) {
            markdown += `---\n\n`;
        }
    });

    markdown += `\n## Next Steps\n\n`;
    markdown += `<!-- simple:start -->\n`;
    markdown += `Try setting up a small project using these ideas. Start with clear folder names and a good README file.\n\n`;
    markdown += `<!-- simple:end -->\n\n`;
    markdown += `<!-- medium:start -->\n`;
    markdown += `Begin by creating a basic tool structure with MANIFEST.json files. Experiment with Cursor's rules system and observe how AI behavior changes with different rule configurations.\n\n`;
    markdown += `<!-- medium:end -->\n\n`;
    markdown += `<!-- advanced:start -->\n`;
    markdown += `Implement a complete toolset following the patterns described. Create operation codes, integrate with MCP servers, and establish automated verification workflows. Consider contributing to open-source AI-first repository templates.\n\n`;
    markdown += `<!-- advanced:end -->\n`;

    return markdown;
}

// Main function
async function main() {
    try {
        const args = parseArgs();
        
        if (!args.topic) {
            console.error('Error: --topic is required');
            process.exit(1);
        }

        console.log('Generating article...');
        console.log(`Topic: ${args.topic}`);
        console.log(`Output: ${args.output}`);
        console.log(`Complexity: ${args.complexity}`);

        // Generate article content
        const article = generateArticleContent(args.topic, args.complexity);

        // Format as Markdown
        const markdown = formatArticle(article);

        // Ensure output directory exists
        const outputDir = path.dirname(args.output);
        if (outputDir !== '.') {
            await fs.mkdir(outputDir, { recursive: true });
        }

        // Write article
        await fs.writeFile(args.output, markdown, 'utf8');

        console.log(`\nArticle generated successfully!`);
        console.log(`Output: ${args.output}`);
        console.log(`Sections: ${article.sections.length}`);

    } catch (error) {
        console.error('Error generating article:', error.message);
        process.exit(1);
    }
}

// Run if called directly
if (require.main === module) {
    main();
}

module.exports = { generateArticleContent, formatArticle };

