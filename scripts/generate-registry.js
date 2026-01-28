import fs from 'fs';
import path from 'path';

/**
 * Registry Generation Script
 * Collates pack manifests and standalone items into a master registry.
 */
async function generate() {
    const rootDir = '/home/igorw/Work/Opencode-Workflows';
    const finalRegistryPath = path.join(rootDir, 'registry.json');
    
    const registry = {
        name: "opencode-workflows",
        version: "1.0.0",
        packs: [],
        standalone: []
    };

    const manifests = [
        'agents/generic/registry.json',
        'agents/vite-react-ts-convex-tailwind/registry.json',
        'agents/parallel-PRD/registry.json',
        'agents/component-engineer/registry.json',
        'agents/create-opencode-plugin/registry.json',
        'agents/opencode-configurator/registry.json',
        'agents/security-reviewer/registry.json',
        'agents/repo-navigator/registry.json',
        'commands/registry.json',
        'cowork/registry.json'
    ];

    for (const relPath of manifests) {
        const fullPath = path.join(rootDir, relPath);
        if (!fs.existsSync(fullPath)) continue;

        try {
            const content = fs.readFileSync(fullPath, 'utf-8');
            const data = JSON.parse(content);
            const baseDir = path.dirname(relPath);

            const normalizedItems = data.items.map(item => ({
                ...item,
                path: path.join(baseDir, item.path)
            }));

            // standalone detection
            if (relPath === 'agents/generic/registry.json' || relPath === 'commands/registry.json') {
                registry.standalone.push(...normalizedItems);
            } else {
                registry.packs.push({
                    name: data.name,
                    description: data.description,
                    path: baseDir,
                    items: normalizedItems
                });
            }
        } catch (e) {
            console.error(`Error processing ${relPath}: ${e.message}`);
        }
    }

    fs.writeFileSync(finalRegistryPath, JSON.stringify(registry, null, 2));
    console.log(`Master registry generated with ${registry.packs.length} packs and ${registry.standalone.length} standalone items.`);
}

generate();
