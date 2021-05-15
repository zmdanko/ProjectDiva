<template>
    <v-card
            max-width="400"
            class="mx-auto"
    >

        <v-app-bar
                dark
                color="pink"
        >

            <v-toolbar-title>ProjectDiva</v-toolbar-title>

            <v-spacer></v-spacer>

        </v-app-bar>

        <v-container>
            <v-row dense>
                <v-col cols="12">
                    <v-card
                            color="#385F73"
                            dark
                            @click="downloadRequest('Android32')"
                    >

                        <v-card-actions>
                            <v-btn text>
                                Android32
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-col>

                <v-col cols="12">
                    <v-card
                            color="#385F73"
                            dark

                            @click="downloadRequest('Win64')"
                    >

                        <v-card-actions>
                            <v-btn text>
                                Win64
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-col>
            </v-row>
        </v-container>
    </v-card>
</template>

<script>
    export default {
        name: 'Download',

        methods: {
            downloadRequest(platform) {
               let a = document.createElement('a');
               a.href = window.location.href+'download/'+platform;
               a.click();
            }
        }
    }
</script>
