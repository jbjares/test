package de.difuture.ekut.pht.test.lib

import org.testcontainers.containers.GenericContainer
import java.net.URI


/**
 * Workaround for Kotlin, as described in :
 *
 * https://github.com/testcontainers/testcontainers-java/issues/318
 *
 * @author Lukas Zimmermann
 */
class SingleExposedPortContainer(imageName: String, private val originalPort : Int)
    : GenericContainer<SingleExposedPortContainer>(imageName) {

    init {
        this.withExposedPorts(originalPort)
    }

    val mappedPort : Int = this.getMappedPort(this.originalPort)

    fun getExternalURI() : URI {

        if (":" in this.containerIpAddress) {

            throw IllegalStateException("For some reason, the IP address of the container contains the ':' character!")
        }
        return URI.create("http://" + this.containerIpAddress + ":" + this.mappedPort)
    }
}
