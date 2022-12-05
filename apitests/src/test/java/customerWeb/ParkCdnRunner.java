package customerWeb;


import com.intuit.karate.junit5.Karate;

class ParkCdnRunner {
    
    @Karate.Test
    Karate testParkCdn() {
        return Karate.run("parks-cdn-get").relativeTo(getClass());
    }    

}