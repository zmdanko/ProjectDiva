<template>
  <v-app>
    <v-main>
      <Download/>
    </v-main>
  </v-app>
</template>


<script>
import Download from './components/Download';

export default {
  name: 'App',

  components: {
    Download,
  },

  data: () => ({
    //
  }),
};
</script>
