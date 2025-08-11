#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

class CodebaseAnalyzer {
    constructor(rootPath = process.cwd()) {
        this.rootPath = rootPath;
        this.structure = [];
        this.stats = {
            totalFiles: 0,
            totalDirectories: 0,
            fileTypes: {},
            totalLines: 0
        };

        // File extensions to analyze
        this.includedExtensions = ['.lua', '.json', '.md', '.txt', '.js', '.ts'];

        // Directories to ignore
        this.ignoredDirs = ['node_modules', '.git', '.vscode', 'dist', 'build'];
    }

    shouldInclude(filePath, stats) {
        const basename = path.basename(filePath);

        // Skip hidden files/directories
        if (basename.startsWith('.') && !basename.startsWith('.project')) {
            return false;
        }

        // Skip ignored directories
        if (stats.isDirectory() && this.ignoredDirs.includes(basename)) {
            return false;
        }

        // Include all directories and files with specific extensions
        return stats.isDirectory() ||
            this.includedExtensions.includes(path.extname(filePath)) ||
            basename === 'default.project.json';
    }

    countLines(filePath) {
        try {
            const content = fs.readFileSync(filePath, 'utf8');
            return content.split('\n').length;
        } catch (err) {
            return 0;
        }
    }

    analyzeFile(filePath, relativePath) {
        const stats = fs.statSync(filePath);
        const ext = path.extname(filePath);

        if (stats.isFile()) {
            this.stats.totalFiles++;
            this.stats.fileTypes[ext] = (this.stats.fileTypes[ext] || 0) + 1;

            if (this.includedExtensions.includes(ext)) {
                const lines = this.countLines(filePath);
                this.stats.totalLines += lines;
                return { lines };
            }
        } else {
            this.stats.totalDirectories++;
        }

        return {};
    }

    traverse(currentPath, indent = '', isLast = true, relativePath = '') {
        const stats = fs.statSync(currentPath);

        if (!this.shouldInclude(currentPath, stats)) {
            return;
        }

        const basename = path.basename(currentPath);
        const connector = isLast ? '└── ' : '├── ';

        let entry = `${indent}${connector}${basename}`;

        if (stats.isFile()) {
            const analysis = this.analyzeFile(currentPath, relativePath);
            const ext = path.extname(currentPath);

            if (analysis.lines) {
                entry += ` (${analysis.lines} lines)`;
            }

            // Add file type indicator
            if (ext === '.lua') entry += ' 🌙';
            else if (ext === '.json') entry += ' ⚙️';
            else if (ext === '.md') entry += ' 📝';
        } else {
            entry += ' 📁';
        }

        this.structure.push(entry);

        if (stats.isDirectory()) {
            try {
                const items = fs.readdirSync(currentPath)
                    .map(item => ({
                        name: item,
                        path: path.join(currentPath, item),
                        relativePath: path.join(relativePath, item)
                    }))
                    .filter(item => {
                        try {
                            return this.shouldInclude(item.path, fs.statSync(item.path));
                        } catch {
                            return false;
                        }
                    })
                    .sort((a, b) => {
                        const aIsDir = fs.statSync(a.path).isDirectory();
                        const bIsDir = fs.statSync(b.path).isDirectory();

                        if (aIsDir && !bIsDir) return -1;
                        if (!aIsDir && bIsDir) return 1;
                        return a.name.localeCompare(b.name);
                    });

                items.forEach((item, index) => {
                    const isLastItem = index === items.length - 1;
                    const newIndent = indent + (isLast ? '    ' : '│   ');
                    this.traverse(item.path, newIndent, isLastItem, item.relativePath);
                });
            } catch (err) {
                this.structure.push(`${indent}    [Error reading directory: ${err.message}]`);
            }
        }
    }

    generateReport() {
        const report = [
            '🏗️  MONSTER LAB TYCOON - CODEBASE ANALYSIS',
            `📅 Generated: ${new Date().toISOString()}`,
            '=' + '='.repeat(60),
            '',
            '📊 PROJECT STATISTICS:',
            `   📁 Total Directories: ${this.stats.totalDirectories}`,
            `   📄 Total Files: ${this.stats.totalFiles}`,
            `   📝 Total Lines of Code: ${this.stats.totalLines}`,
            '',
            '📋 FILE TYPES:',
            ...Object.entries(this.stats.fileTypes)
                .sort(([, a], [, b]) => b - a)
                .map(([ext, count]) => `   ${ext || '[no extension]'}: ${count} files`),
            '',
            '🌳 PROJECT STRUCTURE:',
            ...this.structure,
            '',
            '=' + '='.repeat(60),
            `📊 Analysis complete! Found ${this.stats.totalFiles} files in ${this.stats.totalDirectories} directories.`
        ];

        return report.join('\n');
    }

    run() {
        console.log('🔍 Analyzing codebase...');

        this.traverse(this.rootPath, '', true, '');

        const report = this.generateReport();

        // Write to file
        const outputPath = path.join(this.rootPath, 'CODEBASE_STRUCTURE.txt');
        fs.writeFileSync(outputPath, report);

        console.log(report);
        console.log(`\n💾 Full report saved to: ${outputPath}`);
    }
}

// Run the analyzer
new CodebaseAnalyzer().run();