import fs from 'fs';
import path from 'path';

async function generateRegistry() {
    const rootDir = '/home/igorw/Work/Opencode-Workflows';
    
    const registry = {
        name: "opencode-workflows",
        version: "1.0.0",
        packs: [],
        standalone: []
    };

    const manifestFiles = [
        'agents/component-engineer/registry.json',
        'agents/create-opencode-plugin/registry.json',
        'agents/opencode-configurator/registry.json',
        'agents/parallel-PRD/registry.json',
        'agents/repo-navigator/registry.json',
        'agents/security-reviewer/registry.json',
        'agents/vite-react-ts-convex-tailwind/registry.json',
        'cowork/registry.json',
        'commands2skills/registry.json'
    ];


    for (const relPath of manifestFiles) {
        const fullPath = path.join(rootDir, relPath);
        if (fs.existsSync(fullPath)) {
            try {
                const manifest = JSON.parse(fs.readFileSync(fullPath, 'utf-8'));
                const packDir = path.dirname(relPath);
                const pack = {
                    ...manifest,
                    path: packDir,
                    items: manifest.items.map(item => ({
                        ...item,
                        path: path.join(packDir, item.path)
                    }))
                };
                registry.packs.push(pack);
            } catch (e) {
                console.error(`Error parsing ${relPath}:`, e.message);
            }
        }
    }

    const standaloneFiles = [
        'agents/generic/registry.json',
        '.opencode/command/registry.json',
        'commands/standalone-registry.json'
    ];

    for (const relPath of standaloneFiles) {
        const fullPath = path.join(rootDir, relPath);
        if (fs.existsSync(fullPath)) {
            try {
                const manifest = JSON.parse(fs.readFileSync(fullPath, 'utf-8'));
                const baseDir = path.dirname(relPath);
                registry.standalone.push(...manifest.items.map(item => ({
                    ...item,
                    path: path.join(baseDir, item.path)
                })));
            } catch (e) {
                console.error(`Error parsing ${relPath}:`, e.message);
            }
        }
    }

    fs.writeFileSync(path.join(rootDir, 'registry.json'), JSON.stringify(registry, null, 2));
    console.log(`Registry generated: ${registry.packs.length} packs, ${registry.standalone.length} standalone items.`);
}

generateRegistry();
