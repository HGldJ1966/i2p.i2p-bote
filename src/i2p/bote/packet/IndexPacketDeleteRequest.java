/**
 * Copyright (C) 2009  HungryHobo@mail.i2p
 * 
 * The GPG fingerprint for HungryHobo@mail.i2p is:
 * 6DD3 EAA2 9990 29BC 4AD2 7486 1E2C 7B61 76DC DC12
 * 
 * This file is part of I2P-Bote.
 * I2P-Bote is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * I2P-Bote is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with I2P-Bote.  If not, see <http://www.gnu.org/licenses/>.
 */

package i2p.bote.packet;

import i2p.bote.UniqueId;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import net.i2p.data.DataFormatException;
import net.i2p.data.Hash;
import net.i2p.util.Log;

/**
 * This class is not thread-safe.
 */
@TypeCode('X')
public class IndexPacketDeleteRequest extends CommunicationPacket {
    private Log log = new Log(IndexPacketDeleteRequest.class);
    private Hash emailDestHash;
    private Map<Hash, UniqueId> entries;

    public IndexPacketDeleteRequest(Hash emailDestHash) {
        this.emailDestHash = emailDestHash;
        entries = new HashMap<Hash, UniqueId>();
    }
    
    public IndexPacketDeleteRequest(byte[] data) {
        super(data);
        ByteBuffer buffer = ByteBuffer.wrap(data, HEADER_LENGTH, data.length-HEADER_LENGTH);

        emailDestHash = readHash(buffer);
        entries = new HashMap<Hash, UniqueId>();
        int numEntries = buffer.getShort();
        for (int i=0; i<numEntries; i++) {
            Hash dhtKey = readHash(buffer);
            UniqueId deletionKey = new UniqueId(buffer);
            entries.put(dhtKey, deletionKey);
        }
        
        if (buffer.hasRemaining())
            log.debug("Index Packet Delete Request has " + buffer.remaining() + " extra bytes.");
    }
    
    public void put(Hash dhtKey, UniqueId deletionKey) {
        entries.put(dhtKey, deletionKey);
    }
    
/*    public Map<Hash, UniqueId> getAll() {
        return entries;
    }*/
    
    public Hash getEmailDestHash() {
        return emailDestHash;
    }
    
    public Set<Hash> getDhtKeys() {
        return entries.keySet();
    }

    public UniqueId getDeletionKey(Hash dhtKey) {
        return entries.get(dhtKey);
    }
    
    public void remove(Hash dhtKey) {
        entries.remove(dhtKey);
    }
    
    public int getNumEntries() {
        return entries.size();
    }
    
    @Override
    public byte[] toByteArray() {
        ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
        DataOutputStream dataStream = new DataOutputStream(byteStream);
        
        try {
            writeHeader(dataStream);
            emailDestHash.writeBytes(dataStream);
            dataStream.writeShort(entries.size());
            for (Entry<Hash, UniqueId> entry: entries.entrySet()) {
                dataStream.write(entry.getKey().toByteArray());
                dataStream.write(entry.getValue().toByteArray());
            }
        } catch (DataFormatException e) {
            log.error("Invalid format for email destination.", e);
        } catch (IOException e) {
            log.error("Can't write to ByteArrayOutputStream.", e);
        }
        
        return byteStream.toByteArray();
    }
}