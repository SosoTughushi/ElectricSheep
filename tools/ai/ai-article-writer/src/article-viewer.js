#!/usr/bin/env node

/**
 * Article Viewer Generator
 * Creates an interactive HTML viewer for articles with difficulty level switching
 */

const fs = require('fs/promises');
const path = require('path');

// Parse markdown article and extract sections with complexity levels
function parseArticle(markdown) {
    const sections = [];
    const lines = markdown.split('\n');
    
    let currentSection = null;
    let currentComplexity = null;
    let currentContent = [];
    let inComplexityBlock = false;
    
    // Extract frontmatter
    const frontmatterMatch = markdown.match(/^---\n([\s\S]*?)\n---/);
    const frontmatter = {};
    if (frontmatterMatch) {
        frontmatterMatch[1].split('\n').forEach(line => {
            const match = line.match(/^(\w+):\s*(.+)$/);
            if (match) {
                frontmatter[match[1]] = match[2];
            }
        });
    }
    
    // Extract title
    const titleMatch = markdown.match(/^#\s+(.+)$/m);
    const title = titleMatch ? titleMatch[1] : frontmatter.title || 'Article';
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        
        // Check for section headers
        const sectionMatch = line.match(/^##\s+(.+)$/);
        if (sectionMatch) {
            // Save previous section
            if (currentSection) {
                if (currentComplexity && currentContent.length > 0) {
                    currentSection.content[currentComplexity] = currentContent.join(' ').trim();
                }
                sections.push(currentSection);
            }
            
            // Start new section
            currentSection = {
                title: sectionMatch[1],
                content: {
                    simple: '',
                    medium: '',
                    advanced: ''
                }
            };
            currentComplexity = null;
            currentContent = [];
            inComplexityBlock = false;
            continue;
        }
        
        // Check for complexity markers
        if (line.includes('<!-- simple:start -->')) {
            if (currentComplexity && currentContent.length > 0 && currentSection) {
                currentSection.content[currentComplexity] = currentContent.join(' ').trim();
            }
            currentComplexity = 'simple';
            currentContent = [];
            inComplexityBlock = true;
            continue;
        }
        
        if (line.includes('<!-- medium:start -->')) {
            if (currentComplexity && currentContent.length > 0 && currentSection) {
                currentSection.content[currentComplexity] = currentContent.join(' ').trim();
            }
            currentComplexity = 'medium';
            currentContent = [];
            inComplexityBlock = true;
            continue;
        }
        
        if (line.includes('<!-- advanced:start -->')) {
            if (currentComplexity && currentContent.length > 0 && currentSection) {
                currentSection.content[currentComplexity] = currentContent.join(' ').trim();
            }
            currentComplexity = 'advanced';
            currentContent = [];
            inComplexityBlock = true;
            continue;
        }
        
        if (line.includes('<!--') && line.includes(':end -->')) {
            if (currentComplexity && currentContent.length > 0 && currentSection) {
                currentSection.content[currentComplexity] = currentContent.join(' ').trim();
            }
            currentComplexity = null;
            currentContent = [];
            inComplexityBlock = false;
            continue;
        }
        
        // Collect content for current complexity
        if (currentComplexity && currentSection && inComplexityBlock) {
            // Skip markdown bold markers if they're just labels
            let cleanedLine = line.replace(/^\*\*Simple:\*\*\s*/, '')
                                  .replace(/^\*\*Medium:\*\*\s*/, '')
                                  .replace(/^\*\*Advanced:\*\*\s*/, '')
                                  .trim();
            
            // Skip empty lines and comment markers
            if (cleanedLine && !cleanedLine.startsWith('<!--')) {
                currentContent.push(cleanedLine);
            }
        }
    }
    
    // Save last section
    if (currentSection) {
        if (currentComplexity && currentContent.length > 0) {
            currentSection.content[currentComplexity] = currentContent.join(' ').trim();
        }
        sections.push(currentSection);
    }
    
    return { title, frontmatter, sections };
}

// Generate HTML viewer
function generateHTMLViewer(articleData) {
    const { title, sections } = articleData;
    
    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 1.1em;
        }
        
        .content {
            padding: 40px;
        }
        
        .section {
            margin-bottom: 50px;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }
        
        .section:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .section-title {
            font-size: 1.8em;
            color: #667eea;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .difficulty-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .difficulty-btn {
            padding: 10px 20px;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.95em;
        }
        
        .difficulty-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }
        
        .difficulty-btn.active {
            background: #667eea;
            color: white;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.4);
        }
        
        .difficulty-label {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.85em;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .difficulty-label.simple {
            background: #d4edda;
            color: #155724;
        }
        
        .difficulty-label.medium {
            background: #fff3cd;
            color: #856404;
        }
        
        .difficulty-label.advanced {
            background: #f8d7da;
            color: #721c24;
        }
        
        .section-content {
            font-size: 1.1em;
            line-height: 1.8;
            color: #444;
            min-height: 100px;
            padding: 20px;
            background: white;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        
        .section-content p {
            margin-bottom: 15px;
        }
        
        .section-content.empty {
            color: #999;
            font-style: italic;
        }
        
        .global-controls {
            position: sticky;
            top: 20px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            z-index: 100;
        }
        
        .global-controls h3 {
            margin-bottom: 15px;
            color: #667eea;
            font-size: 1.2em;
        }
        
        .global-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .global-btn {
            padding: 8px 16px;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.9em;
        }
        
        .global-btn:hover {
            background: #667eea;
            color: white;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8em;
            }
            
            .content {
                padding: 20px;
            }
            
            .section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${title}</h1>
            <p>Interactive Article with Adjustable Difficulty Levels</p>
        </div>
        
        <div class="content">
            <div class="global-controls">
                <h3>🌐 Set All Sections To:</h3>
                <div class="global-buttons">
                    <button class="global-btn" onclick="setAllSections('simple')">Simple</button>
                    <button class="global-btn" onclick="setAllSections('medium')">Medium</button>
                    <button class="global-btn" onclick="setAllSections('advanced')">Advanced</button>
                </div>
            </div>
            
            ${sections.map((section, index) => `
                <div class="section" id="section-${index}">
                    <h2 class="section-title">${section.title}</h2>
                    <div class="difficulty-selector">
                        <button class="difficulty-btn ${index === 0 ? 'active' : ''}" 
                                onclick="setDifficulty(${index}, 'simple')"
                                data-section="${index}" 
                                data-difficulty="simple">
                            Simple
                            <span class="difficulty-label simple">Beginner</span>
                        </button>
                        <button class="difficulty-btn ${index === 0 ? '' : 'active'}" 
                                onclick="setDifficulty(${index}, 'medium')"
                                data-section="${index}" 
                                data-difficulty="medium">
                            Medium
                            <span class="difficulty-label medium">Intermediate</span>
                        </button>
                        <button class="difficulty-btn" 
                                onclick="setDifficulty(${index}, 'advanced')"
                                data-section="${index}" 
                                data-difficulty="advanced">
                            Advanced
                            <span class="difficulty-label advanced">Expert</span>
                        </button>
                    </div>
                    <div class="section-content" id="content-${index}">
                        ${section.content.medium || section.content.simple || section.content.advanced || 'No content available'}
                    </div>
                </div>
            `).join('')}
        </div>
    </div>
    
    <script>
        const articleData = ${JSON.stringify(sections, null, 2)};
        
        // Set default difficulty for each section (medium for first, simple for others)
        const defaultDifficulties = articleData.map((_, index) => index === 0 ? 'medium' : 'simple');
        
        // Initialize all sections
        articleData.forEach((section, index) => {
            setDifficulty(index, defaultDifficulties[index]);
        });
        
        function setDifficulty(sectionIndex, difficulty) {
            const section = articleData[sectionIndex];
            const contentDiv = document.getElementById('content-' + sectionIndex);
            const buttons = document.querySelectorAll(\`[data-section="\${sectionIndex}"]\`);
            
            // Update content
            const content = section.content[difficulty] || 'Content not available for this difficulty level.';
            contentDiv.innerHTML = '<p>' + content + '</p>';
            
            // Update button states
            buttons.forEach(btn => {
                if (btn.dataset.difficulty === difficulty) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });
        }
        
        function setAllSections(difficulty) {
            articleData.forEach((_, index) => {
                setDifficulty(index, difficulty);
            });
        }
    </script>
</body>
</html>`;
}

// Main function
async function main() {
    try {
        const args = process.argv.slice(2);
        const markdownPath = args.find(arg => arg.startsWith('--markdown'))?.split('=')[1] || 
                            args[args.indexOf('--markdown') + 1];
        const outputPath = args.find(arg => arg.startsWith('--output'))?.split('=')[1] || 
                          args[args.indexOf('--output') + 1];
        
        if (!markdownPath || !outputPath) {
            console.error('Usage: node article-viewer.js --markdown <path> --output <path>');
            process.exit(1);
        }
        
        console.log('Reading markdown article...');
        const markdown = await fs.readFile(markdownPath, 'utf8');
        
        console.log('Parsing article...');
        const articleData = parseArticle(markdown);
        
        console.log('Generating HTML viewer...');
        const html = generateHTMLViewer(articleData);
        
        // Ensure output directory exists
        const outputDir = path.dirname(outputPath);
        if (outputDir !== '.') {
            await fs.mkdir(outputDir, { recursive: true });
        }
        
        await fs.writeFile(outputPath, html, 'utf8');
        
        console.log(`\n✅ HTML viewer generated successfully!`);
        console.log(`📄 Output: ${outputPath}`);
        console.log(`📊 Sections: ${articleData.sections.length}`);
        
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

module.exports = { parseArticle, generateHTMLViewer };

