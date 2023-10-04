import { KubeConfig } from "@kubernetes/client-node";
import { Command, Flags } from "@oclif/core";

import ApplicationOperator from "../application.js";

export default class Start extends Command {
    static summary = "Run operator.";

    static description =
        "Run operator, which listens to Cartesi Rollups CRDs and spawn Cartesi Rollups Nodes";

    static examples = ["<%= config.bin %> <%= command.id %>"];

    static flags = {
        namespace: Flags.string({
            summary: "kubernetes namespace to watch for applications",
            default: "default",
        }),
    };

    public async run(): Promise<void> {
        const { flags } = await this.parse(Start);

        const kubeConfig = new KubeConfig();
        kubeConfig.loadFromDefault();

        // start operator
        const operator = new ApplicationOperator(kubeConfig, flags.namespace);
        await operator.start();
        const exit = (_reason: string) => {
            operator.stop();
            process.exit(0);
        };
        process
            .on("SIGTERM", () => exit("SIGTERM"))
            .on("SIGINT", () => exit("SIGINT"));
    }
}
