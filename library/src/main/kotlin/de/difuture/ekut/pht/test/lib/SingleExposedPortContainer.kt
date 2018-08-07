package de.difuture.ekut.pht.test.lib

import org.testcontainers.containers.GenericContainer
import java.net.URI


/**
 *
 * Implements a [GenericContainer] that exposes exactly one port for testing.
 *
 * @author Lukas Zimmermann
 * @since 0.0.1
 *
 */
class SingleExposedPortContainer(imageName: String, private val originalPort : Int)
    : GenericContainer<SingleExposedPortContainer>(imageName) {

    init {
        this.withExposedPorts(originalPort)
    }

    private val mappedPort : Int by lazy { this.getMappedPort(this.originalPort) }

    fun getExternalURI() : URI {

        if (":" in this.containerIpAddress) {

            throw IllegalStateException("For some reason, the IP address of the container contains the ':' character!")
        }
        return URI.create("http://" + this.containerIpAddress + ":" + this.mappedPort)
    }
}
